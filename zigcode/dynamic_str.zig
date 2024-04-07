const std = @import("std");

pub fn main() !void {
    var buf: [100]u8 = undefined;
    const str = try std.fmt.bufPrint(&buf, "The salary is {d}", .{23.3});
    std.debug.print("{s}", .{str});
}
