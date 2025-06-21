const std = @import("std");
pub fn main() void {
	getInfo(User);
}

fn getInfo(comptime T: type) void {
	const st = @typeInfo(T).@"struct";
	
	inline for(st.fields) |field|{
		std.debug.print("{s} {}\n",.{field.name,field.type});
	}
}

const User = struct{
	id:u32,
	name:[]const u8,
	age:u32,
};
