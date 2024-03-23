const std = @import("std");

pub fn main() !void{
	const book = .{.name="PHP",.price=23.3,.pages=340};
	std.debug.print("Name={s}, Price={d} and Pages={d}",.{book.name,book.price,book.pages});
}