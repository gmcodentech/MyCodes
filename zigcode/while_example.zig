const std = @import("std");
pub fn main() void{
	const r = 10;
	var i:u8 = 0;
	while(i<r):(i += 1) {
		std.debug.print("{d} ",.{i});
	}
}