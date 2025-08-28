const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const timestamp_ns = std.time.nanoTimestamp();
	 const timestamp_s = @as(u64,@intCast(@divTrunc(timestamp_ns, 1_000_000_000)));

    const epoch_seconds = std.time.epoch.EpochSeconds{ .secs = timestamp_s};
    
    const day_seconds = epoch_seconds.getDaySeconds();
    const epoch_day = epoch_seconds.getEpochDay();
    const year_day = epoch_day.calculateYearDay();
    const month_day = year_day.calculateMonthDay();

	const year = year_day.year;
	const month = month_day.month.numeric();
	const day = month_day.day_index+1;
	
	const hour = day_seconds.getHoursIntoDay();
	const minute = day_seconds.getMinutesIntoHour();
	const seconds = day_seconds.getSecondsIntoMinute();
	
    print("Current Date: {d:0>4}-{d:0>2}-{d:0>2}\n",.{ year, month, day });
	print("Current Time: {d:0>2}:{d:0>2}:{d:0>2}\n",.{hour,minute,seconds});
}

