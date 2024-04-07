//enums.zig

const std = @import("std");
pub fn main() void{
	const Day = enum{
		MON,TUE,WED,THU,FRI,SAT,SUN
	};
	const day:Day = Day.WED;
	if(day == Day.WED){
		std.debug.print("The day is Wendensday",.{});
	}
}