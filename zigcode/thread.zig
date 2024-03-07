const std = @import("std");

fn work(num: u64) void {
    std.time.sleep(2 * std.time.ns_per_s);
    var total: u128 = 0;
    for (0..num + 1) |n| {
        total += n;
    }
    std.debug.print("\n{d}", .{total});
}

fn another_work() void {
    std.time.sleep(1 * std.time.ns_per_s);
    std.debug.print("\nAnother work...", .{});
}

pub fn main() !void {
    std.debug.print("Hello", .{});

    const thread_1 = try std.Thread.spawn(.{}, work, .{@as(u128, 1000000)});
    defer thread_1.join();

    const thread_2 = try std.Thread.spawn(.{}, another_work, .{});

    defer thread_2.join();

    std.debug.print("\nDone", .{});
}
