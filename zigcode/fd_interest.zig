const std = @import("std");

pub fn main() void{
	const roi:f32 = 7.0;
	const p:f32 = 500000.0;
	const months:u8 = 12;
	
	const intr:f32 = (roi/100.0)*p;
	const monthly_intr:f32 = intr/months;
	
	std.debug.print("{d:10.2}",.{monthly_intr});
}