const std = @import("std");
pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	var list = std.ArrayList(u32).init(allocator);
	defer list.deinit();
	
	try list.append(32);
	try list.append(356);
	
	const jsonstr = try std.json.stringifyAlloc(allocator,list.items,.{});
	defer allocator.free(jsonstr);
	
	std.debug.print("{s}",.{jsonstr});
}