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

// NOTE:
// MemoryPool allocator is very useful when we create and destory object frequentyly. 
// Underlying memory allocation uses a separate list of destroyed objects. 
// When we need objects again, the list object is retrieved. 
// First time object are created using GeneralPurposeAllocator allocator. 
// Because of this , this allocation is fast. 
// This makes memory pool allocator work on one type Because it needs to work on same size.