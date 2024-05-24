const std = @import("std");

pub fn main() !void{
	var buf:[32]u8 = undefined;
	var fa = std.heap.FixedBufferAllocator.init(&buf);
	defer fa.reset();
	
	const allocator = fa.allocator();
	
	//The following line raises an error because buf has size 32 bytes, and we are trying to allocate 1 additional byte
	//error : out of memory
	var arr = try allocator.alloc(u8,33);
	arr[0]=23;
	arr[1]=90;
	arr[2]=63;
	arr[3]=86;
	
	std.debug.print("Length is {d}",.{arr.len});
}