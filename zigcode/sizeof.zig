//sizeof.zig

const std = @import("std");
pub fn main() void{
	const i:u128 = 23;
	std.debug.print("The size of i is {d}",.{@sizeOf(@TypeOf(i))});
}

//Output:
//The size of i is 16