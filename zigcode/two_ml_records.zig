const std = @import("std");
 
pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	 
	var list = std.ArrayList(Book).init(allocator);
	defer list.deinit();
	 
	for(0..20_00_000) |_|{
		try list.append(Book{.title="test",.price=0.234});	
	}
	
	var total:f32 = 0.0;
	for(list.items) |item|{
		total += item.price;
	}

	 
	std.debug.print("{d} {d}",.{list.items.len,total});
}
 
const Book = struct{
	title:[]const u8,
	price:f32,
};
 
 