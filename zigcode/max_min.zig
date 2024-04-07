//max_min.zig
const std = @import("std");
pub fn main() void {
    const max_no = @max(3, 4, 34, 32, 35, 6);
    std.debug.print("maximum no is {d}", .{max_no});

    const min_no = @min(3, 4, 34, 32, 35, 6);
    std.debug.print("\nminimum no is {d}", .{min_no});
}

//output:
//maximum no is 35
//minimum no is 3
