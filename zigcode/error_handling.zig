const std = @import("std");
pub fn main() !void {
    const res = divideTwo(2.3, 12.0) catch |err| {
        std.debug.print("{any}", .{err});
        return;
    };

    std.debug.print("{d}", .{res});
}

fn divideTwo(f: f32, s: f32) !f32 {
    if (s == 0.0) {
        return error.DivideByZeroError;
    }

    return f / s;
}
