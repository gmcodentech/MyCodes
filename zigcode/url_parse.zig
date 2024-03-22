const std = @import("std");

pub fn main() !void{
	var url = add(2,3);
	std.debug.print("Hello {any}",.{url});
}

fn add(a:i32,b:i32) i32{
	const x = a + b;
	return x;
}