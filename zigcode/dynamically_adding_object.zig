const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var dpa = std.heap.DebugAllocator(.{}){};
    defer _ = dpa.deinit();
    const allocator = dpa.allocator();

    var list = std.ArrayList(Product).init(allocator);
    defer list.deinit();

    try list.append(try Product.init(allocator, "soap", 23.4, 100));
    try list.append(try Product.init(allocator, "sugar", 24.5, 200));
    try list.append(try Product.init(allocator, "tea", 12.5, 15));
    try list.append(try Product.init(allocator, "milk", 80.5, 45));

    // Print list length
    print("List size: {}\n", .{list.items.len});

    // Optional: print each product
    for (list.items) |product| {
        product.print_product();
    }

    // Cleanup product names (since name is duplicated)
    for (list.items) |*product| {
        product.deinit(allocator);
    }
}

const Product = struct {
    name: []u8, // heap-allocated, mutable buffer
    price: f32,
    units: u32,

    fn init(allocator: std.mem.Allocator, n: []const u8, p: f32, u: u32) !Product {
        const name_copy = try allocator.dupe(u8, n);
        return Product{ .name = name_copy, .price = p, .units = u };
    }

    fn deinit(self: *Product, allocator: std.mem.Allocator) void {
        allocator.free(self.name);
    }

    fn print_product(self: *const Product) void {
        print("Name: {s}, Price: {d:.2}, Units: {}\n", .{ self.name, self.price, self.units });
    }
};