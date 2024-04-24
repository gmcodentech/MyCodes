const std = @import("std");
 
test "arrenaa" {
	
	var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
	defer arena.deinit();
	 
	const allocator = arena.allocator();
	 
	
	const list_json = "[\"one\",\"two\"]";
	const parsed = try std.json.parseFromSlice([][]u8,allocator,list_json,.{});

	 
	for (parsed.value) |item| {
		std.debug.print("{s}",.{item});
	} 
}
