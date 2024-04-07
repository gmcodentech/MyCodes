const std = @import("std");

pub fn main() !void {
    var buf: [100]u8 = undefined;
    var fa = std.heap.FixedBufferAllocator.init(&buf);
    defer fa.reset();

    const allocator = fa.allocator();

    const str = try std.fmt.allocPrint(allocator, "The salary is {d}", .{23});
    defer allocator.free(str);

    std.debug.print("{s}", .{str});
}
