const std = @import("std");

const base64url = std.base64.url_safe_no_pad;
const Hmac = std.crypto.auth.hmac.Hmac;
const HmacSha256 = Hmac(std.crypto.hash.sha2.Sha256);

/// JWT header (we only support HS256 here)
pub const Header = struct {
    alg: []const u8, // algorithm, e.g. "HS256"
    typ: []const u8, // type, e.g. "JWT"
};

/// Public Claims model (extend as you like)
pub const Claims = struct {
    sub: ?[]const u8 = null,
    exp: ?u64 = null, // expiration (seconds)
    nbf: ?u64 = null, // not before (seconds)
    iat: ?u64 = null, // issued at (seconds)
    custom: ?[]const u8 = null,
	
	pub fn deinit(self: *Claims, allocator: std.mem.Allocator) void {
		if (self.sub) |s| allocator.free(s);
		if (self.custom) |s| allocator.free(s);
	}
};

/// Verification options
pub const VerifyOptions = struct {
    /// If null, uses current system time (std.time.timestamp()).
    now: ?u64 = null,

    /// Leeway in seconds for clock skew (applies to exp/nbf/iat)
    leeway_secs: u32 = 60,

    /// Toggle checks (defaults good for web APIs)
    check_exp: bool = true,
    check_nbf: bool = true,
    check_iat: bool = false,

    /// Max how far in the future iat may be (only if check_iat = true)
    max_iat_skew_secs: u32 = 300,
};

pub const JwtError = error{
    InvalidToken,
    InvalidSignature,
    UnsupportedAlg,
    Expired,
    NotYetValid,
    IssuedAtInFuture,
};

/// --- Internal helpers ---

pub fn encodeJson(allocator: std.mem.Allocator, v: anytype) ![]u8 {
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    try std.json.stringify(v, .{}, buf.writer());

    return try buf.toOwnedSlice();
}

fn encodeBase64Url(allocator: std.mem.Allocator, data: []const u8) ![]u8 {
    var out = try allocator.alloc(u8, base64url.Encoder.calcSize(data.len));
    const n = base64url.Encoder.encode(out, data);
    return out[0..n.len];
}

const base64 = std.base64.url_safe_no_pad;

fn decodeBase64Url(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    const size = try base64.Decoder.calcSizeForSlice(input);
    var out = try allocator.alloc(u8, size);
    try base64.Decoder.decode(out, input);
    return out[0..];
}

fn signHS256(allocator: std.mem.Allocator, msg: []const u8, secret: []const u8) ![]u8 {
    var mac: [32]u8 = undefined;
    HmacSha256.create(&mac, msg, secret);

    return try encodeBase64Url(allocator, mac[0..]);
}

/// Constant-time equality for same-length slices
fn timingSafeEql(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    var diff: u8 = 0;
    var i: usize = 0;
    while (i < a.len) : (i += 1) diff |= a[i] ^ b[i];
    return diff == 0;
}

/// Validate exp/nbf/iat using options
fn validateClaims(claims: *const Claims, opts: VerifyOptions) !void {
    const now: u64 = opts.now orelse @as(u64,@intCast(std.time.timestamp()));

    if (opts.check_exp) {
        if (claims.exp) |exp| {
            // valid if now <= exp + leeway
            if (now > exp + opts.leeway_secs) return JwtError.Expired;
        }
    }
    if (opts.check_nbf) {
        if (claims.nbf) |nbf| {
            // valid if now >= nbf - leeway
            if (now + opts.leeway_secs < nbf) return JwtError.NotYetValid;
        }
    }
    if (opts.check_iat) {
        if (claims.iat) |iat| {
            // iat should not be too far in the future
            if (now + opts.max_iat_skew_secs < iat) return JwtError.IssuedAtInFuture;
        }
    }
}

/// --- Public API ---

/// Encode JWT with HS256
pub fn encodeJWT(allocator: std.mem.Allocator, claims: Claims, secret: []const u8) ![]u8 {
    const header_json = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}";

    const header_b64 = try encodeBase64Url(allocator, header_json);
    defer allocator.free(header_b64);

    const payload_json = try encodeJson(allocator, claims);
    defer allocator.free(payload_json);

    const payload_b64 = try encodeBase64Url(allocator, payload_json);
    defer allocator.free(payload_b64);

    // header.payload
    const msg = try std.mem.concat(allocator, u8, &.{ header_b64, ".", payload_b64 });
    defer allocator.free(msg);

    const sig_b64 = try signHS256(allocator, msg, secret);
    defer allocator.free(sig_b64);

    // header.payload.signature
    return try std.mem.concat(allocator, u8, &.{ header_b64, ".", payload_b64, ".", sig_b64 });
}

/// Decode & verify HS256 JWT + validate claims
pub fn decodeJWT(
    allocator: std.mem.Allocator,
    token: []const u8,
    secret: []const u8,
    opts: VerifyOptions,
) !Claims  {
    // Split into 3 parts strictly
    var it = std.mem.tokenizeSequence(u8, token, ".");
    const h_b64 = it.next() orelse return JwtError.InvalidToken;
    const p_b64 = it.next() orelse return JwtError.InvalidToken;
    const s_b64 = it.next() orelse return JwtError.InvalidToken;
    if (it.next() != null) return JwtError.InvalidToken; // must be exactly 3 parts

    // Verify signature: H(header.payload)
    const msg = try std.mem.concat(allocator, u8, &.{ h_b64, ".", p_b64 });
    defer allocator.free(msg);

    const expected_sig_b64 = try signHS256(allocator, msg, secret);
    defer allocator.free(expected_sig_b64);

    if (!timingSafeEql(expected_sig_b64, s_b64))
        return JwtError.InvalidSignature;

    // Decode header & ensure alg = HS256
    const header_json = try decodeBase64Url(allocator, h_b64);
    defer allocator.free(header_json);

    const header = try std.json.parseFromSlice(Header, allocator, header_json, .{});
    defer header.deinit();
    if (!std.mem.eql(u8, header.value.alg, "HS256")) return JwtError.UnsupportedAlg;

    // Decode payload -> Claims
    const payload_json = try decodeBase64Url(allocator, p_b64);
    defer allocator.free(payload_json);

    const parsed = try std.json.parseFromSlice(Claims, allocator, payload_json, .{});
	defer parsed.deinit();

	const claims = Claims{
        .sub = if (parsed.value.sub) |s| try allocator.dupe(u8, s) else null,
        .exp = parsed.value.exp,
        .nbf = parsed.value.nbf,
        .iat = parsed.value.iat,
        .custom = if (parsed.value.custom) |c| try allocator.dupe(u8, c) else null,
    };

    // Validate exp/nbf/iat
    try validateClaims(&claims, opts);
    return claims;
}
