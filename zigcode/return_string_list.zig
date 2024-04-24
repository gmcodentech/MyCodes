const std = @import("std");
 
pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	
	var arena = std.heap.ArenaAllocator.init(gpa.allocator());
	defer arena.deinit();
	 
	const allocator = arena.allocator();
	 
	
	const list = try getList(allocator);

	 
	for (list) |item| {
		std.debug.print("{s}",.{item});
	}
 
}

fn getList(allocator:std.mem.Allocator) ![][]u8 {
	const list_json = "[\"one\",\"two\"]";
	const parsed = try std.json.parseFromSlice([][]u8,allocator,list_json,.{});
	return parsed.value;
}
 