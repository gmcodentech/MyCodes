const std = @import("std");

pub fn main() !void {

	var dbg = std.heap.DebugAllocator(.{}){};
	defer _ = dbg.deinit();
	const allocator = dbg.allocator();

    const password = "anotherpassword";
    const salt = "salt4567890123456"; // Must be at least 8 bytes, recommended 16+
	const pepper = "diffpepper";

    // Parameters for Argon2id
    const params = std.crypto.pwhash.argon2.Params{
        .t = 3,        // Iterations (time cost)
        .m = 1 << 16,  // Memory cost in KiB (here 64 MiB)
        .p = 1,   // Threads
    };

    const dk_len: usize = 16; // derive 32-byte key
    var derived: [dk_len]u8 = undefined;
	
	const concat = try std.fmt.allocPrint(allocator, "{s}{s}", .{password, pepper});
	defer allocator.free(concat);

    try std.crypto.pwhash.argon2.kdf(
		allocator,
        &derived,
        concat,
        salt,
        params,
		.argon2id,
    );

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Argon2id derived key: {s}\n", .{std.fmt.bytesToHex(derived, .lower)});
}
