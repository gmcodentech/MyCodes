const std = @import("std");

pub fn main() void{
	const arr:[2]u32 = [_]u32 {1,2};
	
	std.debug.print("{*}",.{&arr});	
	print_address(&arr);
}


fn print_address(arr:[]const u32) void{
	std.debug.print("\n{*}",.{arr});
}