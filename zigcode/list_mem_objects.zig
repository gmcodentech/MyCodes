const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var dpa = std.heap.DebugAllocator(.{}){};
	defer _ = dpa.deinit();
	const allocator = dpa.allocator();
	
	var list = std.ArrayList(*Product).init(allocator);
	
	defer {
		for(list.items) |p|{
			p.deinit(allocator);
		}
		list.deinit();
	}
	
	
	const product = try Product.init(allocator,"soap",23.4,100);
	
	try list.append(product);
	try list.append(try Product.init(allocator,"sugar",24.5,200));
	try list.append(try Product.init(allocator,"tea",12.5,15));
	try list.append(try Product.init(allocator,"milk",80.5,45));
	
	print("{d}",.{list.items.len});
}

const Product = struct {
	name:[]const u8,
	price:f32,
	units:u32,
	
	fn init(allocator:std.mem.Allocator,n:[]const u8,p:f32,u:u32) !*Product {
		const product = try allocator.create(Product);
		product.* = Product{.name=n,.price=p,.units=u};
		return product;
	}
	
	fn deinit(self:*Product,allocator:std.mem.Allocator) void {
		allocator.destroy(self);
	}
};