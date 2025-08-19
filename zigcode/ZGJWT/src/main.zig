//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

pub fn main() !void {
}

test "HS256 encode/decode success + claim checks" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const secret = "super-secret";
    const now: u64 = 1_700_000_000; // fixed time for test determinism

    const claims = jwt.Claims{
        .sub = "harsh",
        .exp = now + 300, // expires in 5 minutes
        .nbf = now - 60,  // valid since 1 minute ago
        .iat = now - 30,  // issued 30s ago
        .custom = "zig-rocks",
    };

    const token = try jwt.encodeJWT(allocator, claims, secret);
    defer allocator.free(token);
	
	//std.debug.print("Token: {s}\n",.{token});

    const opts = jwt.VerifyOptions{
        .now = now,
        .leeway_secs = 30,
        .check_exp = true,
        .check_nbf = true,
        .check_iat = true,
        .max_iat_skew_secs = 120,
    };

     var decoded = try jwt.decodeJWT(allocator, token, secret, opts);
	 defer decoded.deinit(allocator);
	 
	 //std.debug.print("{s}",.{decoded.sub.?});
	 
	 try std.testing.expectEqualStrings("harsh", decoded.sub.?);
     try std.testing.expectEqualStrings("zig-rocks", decoded.custom.?);
}

// test "Expired token is rejected" {
    // const allocator = std.testing.allocator;

    // const secret = "super-secret";
    // const now: u64 = 2_000_000_000;

    // const claims = jwt.Claims{
        // .sub = "expired",
        // .exp = now - 10,   // expired 10s ago
        // .nbf = null,
        // .iat = now - 1000,
    // };

    // const token = try jwt.encodeJWT(allocator, claims, secret);

    // const opts = jwt.VerifyOptions{
        // .now = now,
        // .leeway_secs = 0,
        // .check_exp = true,
        // .check_nbf = false,
        // .check_iat = false,
    // };

	
    // try std.testing.expectError(error.Expired, jwt.decodeJWT(allocator, token, secret, opts));
// }


const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const jwt = @import("ZGJWT_lib");
