const std = @import("std");

pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	var books = std.ArrayList(Book).init(allocator);
	defer books.deinit();
	
	try books.append(.{.title="PHP",.price=234.3,.pages=234});
	try books.append(.{.title="NET",.price=232.2,.pages=140});
	
	for (books.items) |*book| {
		std.debug.print("\nTitle: {s} Price: {d} Pages: {d}",.{book.title,book.price, book.pages});
	}
}

const Book = struct{
	title:[]const u8,
	price:f32,
	pages:u32,
};