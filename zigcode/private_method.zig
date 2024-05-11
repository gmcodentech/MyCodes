const std = @import("std");
const Product = @import("mod_product.zig").Product;
pub fn main() !void{

	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	 
	const product = try Product.init(allocator,"Coffee",234.5);
	defer product.deinit();
	 
	//_getDiscountedPrice is not marked with 'pub' so it is not accessible here
	const discounted_price = Product._getDiscountedPrice(product.price,10.0); //product.getPrice();
	 
	std.debug.print("Title: {s}   Price:{d}",.{product.title,discounted_price});
	 
}