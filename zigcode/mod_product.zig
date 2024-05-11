const std = @import("std");

 
pub const Product = struct{
	title:[]const u8,
	price:f32,
	allocator:std.mem.Allocator,
	 
	const Self = @This();
	 
	pub fn init(allocator:std.mem.Allocator,title:[]const u8, price:f32) !*Self{
		const product = try allocator.create(Product);
		product.* = Self{.allocator = allocator,.title = title,.price=price};
		return product;
	}
	//private method not accessible in other modules
	fn _getDiscountedPrice(price:f32,discount:f32) f32{
		return price - (price * discount/100.0);
	}
	 
	pub fn getPrice(self:*Self) f32{
		return _getDiscountedPrice(self.price,5.0);
	}
	 
	pub fn deinit(self:*Self) void{
		self.allocator.destroy(self);
	}	 
	 
};