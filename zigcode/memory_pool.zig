//memory_pool_example.zig
 
const std = @import("std");
pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	 
	var user_pool = std.heap.MemoryPool(User).init(allocator);
	defer user_pool.deinit();	
	 
	const user = try user_pool.create();
	user.* = .{.id=123};
	defer user_pool.destroy(user);
	 
	std.debug.print("{d}",.{user.id});
}
 
const User = struct{
	id:u32,
};