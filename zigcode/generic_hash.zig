const std = @import("std");

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

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const text: []const u8 = "V";

    var hasher = HexHash(std.crypto.hash.sha3.Sha3_512).init(allocator);
    defer hasher.deinit();
    try hasher.hex_hash(text);
    std.debug.print("{s}", .{hasher.hex_digest});
}

test "sha384"{
	const h2 = "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7";
	const text="abc";
	
	var hasher = HexHash(std.crypto.hash.sha2.Sha384).init(std.testing.allocator);
    defer hasher.deinit();
    try hasher.hex_hash(text);
	
	try std.testing.expectEqualStrings(hasher.hex_digest,h2);
}

test "md5"{
	const expected = "900150983cd24fb0d6963f7d28e17f72";
	const text="abc";
	
	var hasher = HexHash(std.crypto.hash.Md5).init(std.testing.allocator);
    defer hasher.deinit();
    try hasher.hex_hash(text);
	
	try std.testing.expectEqualStrings(hasher.hex_digest,expected);
}
	