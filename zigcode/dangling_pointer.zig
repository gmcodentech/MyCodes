//! Dangling Pointer Example:

const std = @import("std");

const Person = struct{
	name:[]const u8,
	power:u32,
};

fn getPerson(p:u32) *Person{
	var user = Person{.name="abc",.power=100};
	user.power+=p;
	return &user;
}

//uncomment user2 and expectEqual for user2 and 
//see how address of user2 is present in user1 location 
//and so the values are invalid


test "test1"{
	const user1 = getPerson(33);
	//const user2 = getPerson(23);
	
	try std.testing.expectEqual(user1.*.power,133);
	
	//try std.testing.expectEqual(user2.*.name,"abc");
}