const std = @import("std");

fn printFun(input: u32) void{
	std.debug.print("{d}",.{input});
}

fn callFunction(input:u32, comptime f: *const fn(u32) void) void{
	f(input);
}

fn addAndDisplay(input:u32) void{
	const r = input + 100;
	std.debug.print("Result: {d}",.{r});
}

pub fn main() void{
	callFunction(56,addAndDisplay);
}