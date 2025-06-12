const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var dba = std.heap.DebugAllocator(.{}){};
	defer _ = dba.deinit();
	const allocator = dba.allocator();
	
	const book = try Book.init(allocator,".Net",250);
	defer book.deinit();
	
	//book.title="PHP";
	//print("Book information - Title: {s}   Price: {d}",.{book.title,book.price});
	//checkPrice(book);
	
	var books = std.ArrayList(*const Book).init(allocator);
	defer books.deinit();
	try books.append(book);
	const book2 = try Book.init(allocator,"PHP",300.0);
	defer book2.deinit();
	try books.append(book2);
	const book3 = try Book.init(allocator,"Zig",120.0);
	defer book3.deinit();
	try books.append(book3);
	
	try books.append(&Book{.title="Java",.price=155});
	try books.append(&Book{.title="Nim",.price=985});
	try books.append(&Book{.title="Rust",.price=700});


	for (books.items) |b| {
		checkPrice(b);
	}
	
}

pub fn checkPrice(book: *const Book) void{
	//book.price += 2; //error, can't change book because it is a const object
	print("\nName: {s}  Price: {d}",.{book.title,book.price});
}

const Book = struct{
	title: []const u8,
	price: f32,
	allocator: ?std.mem.Allocator=null,
	
	const Self = @This();
	
	fn init(allocator:std.mem.Allocator,title:[]const u8, price:f32) !*const Self{
		const book = try allocator.create(Self);
		book.* = Self{.allocator=allocator, .title=title, .price=price};
		return book;
	}
	
	fn deinit(self:*const Self) void {
		if(self.allocator)|alloc|{
			alloc.destroy(self);
		}
	}
}; 