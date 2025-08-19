const std = @import("std");

pub fn main() !void {
    const password = "mysecretpassword";
    const salt = "random_salt_123";

    // PBKDF2-HMAC-SHA256 parameters
    const iterations: u32 = 100_000;
    const dk_len: usize = 32; // derive 32-byte key

    var derived: [dk_len]u8 = undefined;

    try std.crypto.pwhash.pbkdf2(
        &derived,
        password,
        salt,
        iterations,
        std.crypto.auth.hmac.sha2.HmacSha256,
    );

    // Print derived key as hex
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Derived key: {s}\n", .{std.fmt.bytesToHex(derived, .lower)});
}


fn HexHash(comptime Hasher: anytype) type {
    return struct {
        allocator: std.mem.Allocator,
        hex_digest: []u8 = undefined,

        const Self = @This();
        fn init(allocator: std.mem.Allocator) Self {
            return Self{ .allocator = allocator };
        }

        fn hex_hash(self: *Self, input: []const u8) !void {
            const digest = _hasher_digest(input);

            self.hex_digest = try std.fmt.allocPrint(
                self.allocator,
                "{s}",
                .{std.fmt.fmtSliceHexLower(&digest)},
            );
        }
        fn _hasher_digest(input: []const u8) [Hasher.digest_length]u8 {
            var hasher = Hasher.init(.{});
            hasher.update(input);
            var out: [Hasher.digest_length]u8 = undefined;
            hasher.final(out[0..]);
            return out;
        }

        fn deinit(self: *Self) void {
            self.allocator.free(self.hex_digest);
        }
    };
}