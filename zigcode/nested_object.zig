const std = @import("std");

pub fn main() !void{
	const allocator = std.heap.page_allocator;
	const customer = try allocator.create(Customer);
	defer allocator.destroy(customer);
	
	customer.* = Customer{.name="Vijay", .address = Address{.city="Mumbai",.pin="400034"}};
	std.debug.print("Customer Details: \n",.{});
	std.debug.print("Name: {s}\n",.{customer.name});
	std.debug.print("City: {s}   Pincode: {s}",.{customer.address.city,customer.address.pin});
}

const Address = struct {
	city:[]const u8,
	pin:[]const u8,
};

const Customer = struct {
	name:[]const u8,
	address:Address,
};