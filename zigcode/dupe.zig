const std = @import("std");
const print = std.debug.print;

pub fn main() !void{

	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	const name = "hello";
	const owned_name = try allocator.dupe(u8,name);
	defer allocator.free(owned_name);
	print("{s}",.{owned_name});
}