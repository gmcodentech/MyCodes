const std = @import("std");

pub fn main() !void {
    const count = 10000;
    var threads: [count]std.Thread = undefined;

    // spawning threads
    for (0..count) |i| {
        threads[i] = try std.Thread.spawn(.{}, disp, .{});
    }

    // waiting for all threads to finish
    for (0..count) |i| {
        threads[i].join();
    }

    std.debug.print("done", .{});
}

fn disp() void {
    _ = 10;
}