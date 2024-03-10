const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
	const allocator = std.heap.page_allocator;
	
	var book = try allocator.create(Book);
	defer allocator.destroy(book);
	book.title="PHP";
	book.price=23.4;
	book.pages=230;
	
	const json_book = try std.json.stringifyAlloc(allocator,book,.{.whitespace=.indent_4});
	defer allocator.free(json_book);
	
	print("{s}",.{json_book});
	
	const parsed = try std.json.parseFromSlice(Book,allocator,json_book,.{});
	defer parsed.deinit();
	
	const book_parsed = parsed.value;
	
	print("\nTitle:{s} Price:{d:3.2} Pages:{}",.{book_parsed.title,book_parsed.price,book_parsed.pages});
}


const Book = struct{
	title:[]const u8,
	price:f32,
	pages:u32,
};