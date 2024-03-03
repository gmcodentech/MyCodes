const std = @import("std");

pub fn main() void {
    var arr: [100]u8 = undefined;
    @memset(&arr, 0);
    std.debug.print("{d}", .{arr[33]});

    //const array
    const carr: [100]u32 = [_]u32{0} ** 100;
    //carr[23]=1; <------------------------------------------- error, cannot assign to constant
    std.debug.print("\n{d}", .{carr[33]});
}
