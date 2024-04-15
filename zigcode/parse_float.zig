const std=@import("std");

pub fn main() !void{
	const f_str = "24.23";
	const fv = std.fmt.parseFloat(f32,f_str);
	std.debug.print("{!}",.{fv});
}