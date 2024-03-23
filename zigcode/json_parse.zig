const std = @import("std");

pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	const s = 
		\\[	"PHP","NET","Java","Zig","Rust"]
		;
	
	const parsed = try std.json.parseFromSlice([][]const u8,allocator,s,.{});
	defer parsed.deinit();
	
	for (parsed.value) |*e|{
		std.debug.print("{s}\n",.{e.*});
	}
}