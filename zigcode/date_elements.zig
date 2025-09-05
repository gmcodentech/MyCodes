const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const str = "2024-11-19T18:30:00.000Z";

    // Split date and time
    var dt = std.mem.splitScalar(u8, str, 'T');
    const date_str = dt.next().?;
    const time_str_full = dt.next().?;
    const time_str = time_str_full[0..8]; // strip ".000Z"

    // Split date into year, month, day
    var date_it = std.mem.splitScalar(u8, date_str, '-');
    const year = try parseInt(date_it.next().?, 10);
    const month = try parseInt(date_it.next().?, 10);
    const day = try parseInt(date_it.next().?, 10);

    // Split time into hour, minute, second
    var time_it = std.mem.splitScalar(u8, time_str, ':');
    const hour = try parseInt(time_it.next().?, 10);
    const minute = try parseInt(time_it.next().?, 10);
    const second = try parseInt(time_it.next().?, 10);

    print("Y:{d} M:{d} D:{d} H:{d} Min:{d} S:{d}\n",
        .{ year, month, day, hour, minute, second });
}

fn parseInt(str: []const u8, base: u8) !u32 {
    return try std.fmt.parseInt(u32, str, base);
}