const stdlib = @import("std");
pub fn main() void{
	const arr = [_]u32{23,2,435};
	for (arr) |e|{
		stdlib.debug.print("{}\n",.{e});
	}
	const name:[]const u8 = "Gautam";
	stdlib.debug.print("{*}",.{&name});
	displayName(&name);
}

fn displayName(name:*const []const u8)void{
	stdlib.debug.print("{*}\n",.{name});
	stdlib.debug.print("{s}",.{name.*});
}