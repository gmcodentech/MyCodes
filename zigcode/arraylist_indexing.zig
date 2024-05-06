const std = @import("std");
 
pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	 
	var list = std.ArrayList(u32).init(allocator);
	defer list.deinit();
	 
	try list.append(34);
	try list.append(54);
	 
	std.debug.print("{d} {d}",.{list.items[0],list.items[1]});
}