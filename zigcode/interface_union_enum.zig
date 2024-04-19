const std = @import("std");
   
const Animal = union(enum){
	dog:Dog,
	cat:Cat,
	  
	fn walk(self:Animal,speed:u32) !void{
		switch(self){
			.dog => |dog| try dog.walk(speed),
			.cat => |cat| try cat.walk(speed),
		}
	}
};
   
const Dog = struct{
	age:u32,
	  
	fn walk(self:Dog,speed:u32) !void{
		std.debug.print("dog {d}, is walking with speed {d}\n",.{self.age,speed});
	}
};
  
const Cat = struct{
	color: []const u8,
	fn walk(self:Cat,speed:u32) !void{
		std.debug.print("{s} cat is walking at {d}\n",.{self.color,speed});
	}
};
   
   
pub fn main() !void{
	const animal = Animal{.dog = Dog{.age=5}};
	try animal.walk(32);
	const animal2 = Animal{.cat = Cat{.color="red"}};
	try animal2.walk(8);
}