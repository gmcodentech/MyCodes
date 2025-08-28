const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
 var dbg = std.heap.DebugAllocator(.{}){};
 defer _ = dbg.deinit();
 const allocator = dbg.allocator();
 
 const date_time = try getToday(allocator);
 defer allocator.free(date_time);
 
 print("{s}",.{date_time});
}


pub fn getToday(allocator:std.mem.Allocator)![]u8{
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
	
	return try std.fmt.allocPrint(allocator,"{d:0>4}-{d:0>2}-{d:0>2} {d:0>2}:{d:0>2}:{d:0>2}",
		.{ year, month, day, hour, minute, seconds});
}

