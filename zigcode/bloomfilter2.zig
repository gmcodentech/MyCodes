const std = @import("std");

test "bf test" {
    const allocator = std.testing.allocator;
    const size: usize = 1000;
    var bf = try Bloomfilter.init(allocator, size);
    defer bf.deinit();
    const bit_pos = try bf.get_bit_position(allocator, "Gautam") % size;
    bf.set(bit_pos);
    const check_if_set = bf.check(bit_pos);
    std.debug.print("{}", .{check_if_set});
}

const Bloomfilter = struct {
    allocator: std.mem.Allocator,
    filter: []u1,

    const Self = @This();

    fn init(allocator: std.mem.Allocator, size: usize) !*Self {
        const bf = try allocator.create(Self);
        bf.* = .{ .allocator = allocator, .filter = try allocator.alloc(u1, size) };
        @memset(bf.filter, 0);
        return bf;
    }
	
	fn store(self:*Self,text:[]const u8) !bool{
	
		const hash_functions:[2][]u8 = [_][]u8 {"Sha256","Sha384"};
	
		const digest = get_hasher_digest(std.crypto.hash.sha2.Sha256, text);

		const hex_digest = try std.fmt.allocPrint(
			self.allocator,
			"{s}",
			.{std.fmt.fmtSliceHexLower(&digest)},
		);
		defer self.allocator.free(hex_digest);

		var total: usize = 0;
		for (hex_digest) |n| {
			total += n;
		}

		return total;
	}

    fn set(self: *Self, index: usize) void {
        self.filter[index] = 1;
    }

    fn check(self: *Self, index: usize) bool {
        return self.filter[index] == 1;
    }

    fn deinit(self: *Self) void {
        self.allocator.free(self.filter);
        self.allocator.destroy(self);
    }
	
	//private functions
	fn get_hasher_digest(comptime Hasher: anytype, input: []const u8) [Hasher.digest_length]u8 {
		var hasher = Hasher.init(.{});
		hasher.update(input);
		return hasher.finalResult();
	}
};
