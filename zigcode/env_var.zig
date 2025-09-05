const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var dbg = std.heap.DebugAllocator(.{}){};
	defer _ = dbg.deinit();
	const allocator = dbg.allocator();
	
	const env_var =  try std.process.getEnvVarOwned(allocator,"secret_key");
	print("value of the variable is {s}",.{env_var});
	allocator.free(env_var);
	
}
