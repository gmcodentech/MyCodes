const std = @import("std");
const print = std.debug.print;
pub fn main() void{
	var func:*const fn(msg:[]const u8) void=undefined;
	func=hi;
	func("abc");
	func=hello;
	func("abc");
}

fn hi(message:[]const u8) void{
	print("Hi {s}\n",.{message});
}

fn hello(message:[]const u8) void{
	print("Hello {s}\n",.{message});
}