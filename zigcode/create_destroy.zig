const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    var book = try allocator.create(Book);
    defer allocator.destroy(book);

    book.title = "PHP";
    book.price = 23.3;
    book.pages = 350;

    std.debug.print("{any}", .{book});
}

const Book = struct { title: []const u8, price: f32, pages: u32 };
