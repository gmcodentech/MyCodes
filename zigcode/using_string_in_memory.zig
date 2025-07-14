const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var dbg = std.heap.DebugAllocator(.{}){};
	defer _ = dbg.deinit();
	const allocator = dbg.allocator();
	
	var name:[]u8 = undefined;
	name = try allocator.dupe(u8,"Harshad");
	defer allocator.free(name);
	
	print("{s}",.{name});
}