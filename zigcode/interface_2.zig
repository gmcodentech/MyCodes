const std = @import("std");
      
const Animal = struct{
	ptr: *anyopaque,
	walkfn: *const fn(ptr:*anyopaque,speed:u32) anyerror!void,
	      
	fn walk(animal:Animal,speed:u32) !void{
		try animal.walkfn(animal.ptr,speed);
	}
};
      
      
const Dog = struct{
	age:u32,
		      
	fn walk(ptr:*anyopaque,speed:u32) !void{
		const self:*Dog = @ptrCast(@alignCast(ptr));
		std.debug.print("dog is {d} years old and is walking with speed {d}\n",.{self.age,speed});
	}
	      
	fn animal(self:*Dog) Animal{
		return .{.ptr = self, .walkfn = walk};
	}
};

const Cat = struct{
	color:[]const u8,
	
	fn walk(ptr:*anyopaque,speed:u32) !void{
		const self:*Cat = @ptrCast(@alignCast(ptr));
		std.debug.print("cat with color {s} is walking with speed {d}\n",.{self.color,speed});
	}
	
	fn animal(self:*Cat) Animal{
		return .{.ptr = self,.walkfn = walk};
	}
};

const AnimalWalker = struct{
	fn walk(animal:Animal) !void{
		try animal.walk(20);
	}
};
      
pub fn main() !void{
	var dog = Dog{.age=12};
	var cat = Cat{.color="grey"};
	const animals:[2]Animal = [_]Animal{dog.animal(),cat.animal()};
	for (animals) |animal|{
		try animal.walk(123);
	}
}
      
      