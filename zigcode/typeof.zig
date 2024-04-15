const std = @import("std");

pub fn main() void {
	const type_of_float = @TypeOf(f32);
	if (type_of_float == @TypeOf(f32)){
		std.debug.print("it's float",.{});
	}else {
		std.debug.print("it's not a float",.{});
	}	
}