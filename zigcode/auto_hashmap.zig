const std = @import("std");

pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	var hashmap = std.AutoHashMap(i32,[]const u8).init(allocator);
	defer hashmap.deinit();
	
	try hashmap.put(23,"twenty three");
	try hashmap.put(20,"twenty");

	
	const result = hashmap.get(23) orelse null;
	if(result) |r|{
		std.debug.print("{s}",.{r});
	}	
}