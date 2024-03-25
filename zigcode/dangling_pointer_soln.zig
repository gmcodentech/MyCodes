//! Dangling Pointer Example:

const std = @import("std");

const Person = struct{
	name:[]const u8,
	power:u32,
};

fn getPerson(allocator:std.mem.Allocator,p:u32) !*Person{
	const user = try allocator.create(Person);
	user.* = Person{.name="abc",.power=100+p};
	return user;
}

//uncomment user2 and expectEqual for user2 and 
//see how address of user2 is present in user1 location 
//and so the values are invalid

test "test1"{
	const allocator = std.testing.allocator;
	
	const user1 = try getPerson(allocator,33);
	defer allocator.destroy(user1);
	
	const user2 = try getPerson(allocator,23);
	defer allocator.destroy(user2);
						  				
	try std.testing.expectEqual(user1.power,133);
	
	try std.testing.expectEqual(user2.name,"abc");
}
