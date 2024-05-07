const std = @import("std");
pub fn main() void{
	display(24);
	display(.{.a=1,.b=2});
	display(2+5);
	display(33.5);
	display(.{2,3,4});
	
}

fn display(value:anytype) void{
	std.debug.print("{any}\n",.{value});
}