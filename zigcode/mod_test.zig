const std = @import("std");
const Math = @import("mods.zig").Math;

pub fn main() void{
	var maths = Math.init(23,3);
	const result = (&maths).add();
	std.debug.print("Result is {d}",.{result});
}