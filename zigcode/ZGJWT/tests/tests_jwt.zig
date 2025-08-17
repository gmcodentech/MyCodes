//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
}

test "HS256 encode/decode success + claim checks" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const secret = "super-secret";
    const now: u64 = 1_700_000_000; // fixed time for test determinism

    const claims = jwt.Claims{
        .sub = "sayaji",
        .exp = now + 300, // expires in 5 minutes
        .nbf = now - 60,  // valid since 1 minute ago
        .iat = now - 30,  // issued 30s ago
        .custom = "zig-rocks",
    };

    const token = try jwt.encodeJWT(allocator, claims, secret);
    defer allocator.free(token);

    const opts = jwt.VerifyOptions{
        .now = now,
        .leeway_secs = 30,
        .check_exp = true,
        .check_nbf = true,
        .check_iat = true,
        .max_iat_skew_secs = 120,
    };

    const decoded = try jwt.decodeJWT(allocator, token, secret, opts);
    defer allocator.free(decoded);

    try std.testing.expectEqualStrings("sayaji", decoded.sub.?);
    try std.testing.expectEqualStrings("zig-rocks", decoded.custom.?);
}

test "Expired token is rejected" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const secret = "super-secret";
    const now: u64 = 2_000_000_000;

    const claims = jwt.Claims{
        .sub = "expired",
        .exp = now - 10,   // expired 10s ago
        .nbf = null,
        .iat = now - 1000,
    };

    const token = try jwt.encodeJWT(allocator, claims, secret);
    defer allocator.free(token);

    const opts = jwt.VerifyOptions{
        .now = now,
        .leeway_secs = 0,
        .check_exp = true,
        .check_nbf = false,
        .check_iat = false,
    };

    try std.testing.expectError(jwt.JwtError.Expired, jwt.decodeJWT(allocator, token, secret, opts));
}

test "nbf in the future is rejected unless leeway covers it" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const secret = "super-secret";
    const now: u64 = 2_000_000_000;

    const claims = jwt.Claims{
        .sub = "future",
        .nbf = now + 20, // not valid yet
        .exp = now + 1000,
    };

    const token = try jwt.encodeJWT(allocator, claims, secret);
    defer allocator.free(token);

    // No leeway -> should fail
    {
        const opts = jwt.VerifyOptions{
            .now = now,
            .leeway_secs = 0,
            .check_exp = true,
            .check_nbf = true,
        };
        try std.testing.expectError(jwt.JwtError.NotYetValid, jwt.decodeJWT(allocator, token, secret, opts));
    }

    // With leeway 30s -> should pass
    {
        const opts2 = jwt.VerifyOptions{
            .now = now,
            .leeway_secs = 30,
            .check_exp = true,
            .check_nbf = true,
        };
        const decoded = try jwt.decodeJWT(allocator, token, secret, opts2);
        defer allocator.free(decoded);
        try std.testing.expectEqualStrings("future", decoded.sub.?);
    }
}


const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const jwt = @import("HarshaJWT_lib");
