const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var dbg = std.heap.DebugAllocator(.{}){};
	defer _=dbg.deinit();
	
	const allocator = dbg.allocator();
	
	const file_path = "user.html";
	const file = try std.fs.cwd().openFile(file_path,.{});
	defer file.close();
	
	const contents = try file.reader().readAllAlloc(allocator,std.math.maxInt(usize));
	defer allocator.free(contents);
	
	print("{s}",.{contents});
	
}