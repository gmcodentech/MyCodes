const std = @import("std");
const print = std.debug.print;
const Day = enum{
	Mon,
	Tue,
	Wed,
	Thur,
	Fri,
	Sat,
	Sun
};
pub fn main() !void{
	const day:Day = .Mon;
	if(day == .Mon){
		print("success",.{});
	}else{
		print("failed",.{});
	}
}