const std = @import("std");

pub fn main() !void {
    var buf: [100]u8 = undefined;
    const str = try std.fmt.bufPrint(&buf, "The salary is {d}", .{23.3});
    std.debug.print("{s}", .{str});
	
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	const str = try std.fmt.allocPrint(allocator,"The age is {d}",.{34});
	defer allocator.free(str);
	std.debug.print("{s}",.{str});
}
}
