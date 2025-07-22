const std = @import("std");
const print = std.debug.print;

pub fn main() void{
	print("{d}",.{start()});
}

fn start() i32{
	defer end();
	defer met();
	return 345;
}

fn end()void{
	print("end",.{});
}

fn met()void{
	print("method",.{});
}