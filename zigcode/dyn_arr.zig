const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const size: usize = 10;
    const arr: []u32 = try allocator.alloc(u32, size);
    defer allocator.free(arr);
    arr[0] = 105;
    std.debug.print("{d}", .{arr[0]});
}
