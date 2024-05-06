const std = @import("std");

pub fn main() !void{
	const allocator = std.heap.page_allocator;
	const books = try getFiveBooks(allocator);
	defer allocator.free(books);
	
	for(books) |*book|{
		std.debug.print("{s} {d}\n",.{book.title,book.pages});
	}
	
	const new_books = try getBooks(allocator);
	defer new_books.deinit();
	
	for(new_books.items) |*nk|{
		std.debug.print("{s} {d}\n",.{nk.title,nk.pages});
	}
	
	for(getNos()) |n|{
		std.debug.print("{d} ",.{n});
	}

}

fn getNos() [2]u32{
	return [_]u32 {34,23};
}

fn getFiveBooks(allocator:std.mem.Allocator) ![]Book{
	var books = try allocator.alloc(Book,2);
	books[0]=Book{.title=".NET",.pages=220};
	books[1]=Book{.title=".PHP",.pages=850};
	
	return books;
}

fn getBooks(allocator:std.mem.Allocator) !std.ArrayList(Book){
	var books = std.ArrayList(Book).init(allocator);
	try books.append(Book{.title=".NET",.pages=220});
	try books.append(Book{.title="PHP",.pages=800});
	
	return books;
}

const Book = struct{
	title:[]const u8,
	pages:u32,
};