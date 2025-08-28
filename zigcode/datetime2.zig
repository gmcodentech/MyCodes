const std = @import("std");
const print = std.debug.print;

/// Returns formatted local date-time string (dd/MM/yyyy hh:mm:ss) for a given timezone offset
pub fn getLocalDateTime(tz_hours: i8, tz_minutes: i8) !void {
    //var buf: [32]u8 = undefined;
    //var writer = std.io.fixedBufferWriter(&buf);

    const now = std.time.nanoTimestamp();

    // Convert nanoseconds → seconds
    const epoch_secs: u64 = @as(u64,@intCast(@divTrunc(now, 1_000_000_000)));
    const epoch_seconds = std.time.epoch.EpochSeconds{ .secs = @as(u64,@intCast(epoch_secs)) };

    var day_seconds = epoch_seconds.getDaySeconds();
    var epoch_day = epoch_seconds.getEpochDay();
    var year_day = epoch_day.calculateYearDay();
    var month_day = year_day.calculateMonthDay();

    // UTC time
    var hour: i32 = @as(i32,@intCast(day_seconds.getHoursIntoDay())) + tz_hours;
    var minute: i32 = @as(i32,@intCast(day_seconds.getMinutesIntoHour())) + tz_minutes;
    const second: i32 = @as(i32,@intCast(day_seconds.getSecondsIntoMinute()));

    // Adjust minutes → hours
    if (minute >= 60) {
        hour += @divTrunc(minute,60);
        minute =  @rem(minute,60);
    } else if (minute < 0) {
        hour += @divTrunc(minute,60) - 1;
        minute = 60 +  @rem(minute,60);
    }

    // Adjust hours → days
    var days_offset: i32 = 0;
    if (hour >= 24) {
        days_offset = @divFloor(hour,24);
        hour = @rem(hour,24);
    } else if (hour < 0) {
        days_offset = @divFloor(hour,24) - 1;
        hour = 24 + @rem(hour,24);
    }

    // Apply day offset
	const dayt = @as(i64,@intCast(epoch_day.day))+days_offset;
    const new_epoch_day = std.time.epoch.EpochDay{ .day = @as(u47,@intCast(dayt)) };
    year_day = new_epoch_day.calculateYearDay();
    month_day = year_day.calculateMonthDay();

    const day = month_day.day_index + 1;
    const month = month_day.month.numeric() + 1;
    const year = year_day.year;

    // Format as dd/MM/yyyy hh:mm:ss
    //try writer.print("{d:0>2}/{d:0>2}/{d:0>4} {d:0>2}:{d:0>2}:{d:0>2}", .{ day, month, year, hour, minute, second });
	print("{d:0>2}/{d:0>2}/{d:0>4} {d:0>2}:{d:0>2}:{d:0>2}", .{ day, month, year, hour, minute, second });
    //return writer.toSlice();
}

pub fn main() !void {
	try getLocalDateTime(5, 30);
    // const dt = try getLocalDateTime(5, 30); // IST
    // print("{}\n", .{dt});
}
