const std = @import("std");
   
const Animal = struct{
   
	ptr : *anyopaque,
	walkfn : *const fn(ptr:*anyopaque,speed:u32) anyerror!void,
	   
	fn walk(animal:*Animal,speed:u32) !void{
		try animal.walkfn(animal.ptr,speed);
	}
   
};
   
const Dog = struct{
	age:u32,
	allocator:std.mem.Allocator,
   
	   
	fn walk(ptr:*anyopaque,speed:u32) !void{
		const self:*Dog = @ptrCast(@alignCast(ptr));
		std.debug.print("dog {d}, is walking at {d} miles/hr\n",.{self.age,speed});
	}
	   
	fn animal(self:*Dog) !*Animal{
		const obj = try self.allocator.create(Animal);
		obj.* = Animal{.ptr = self,.walkfn=walk};
		return obj;
	}
};


const Cat = struct{
	color:[]const u8,
	allocator:std.mem.Allocator,
   
	   
	fn walk(ptr:*anyopaque,speed:u32) !void{
		const self:*Cat = @ptrCast(@alignCast(ptr));
		std.debug.print("{s} cat is walking at {d} miles/hr\n",.{self.color,speed});
	}
	   
	fn animal(self:*Cat) !*Animal{
		const obj = try self.allocator.create(Animal);
		obj.* = Animal{.ptr = self,.walkfn=walk};
		return obj;
	}
};

   
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	var dog = Dog{.age=1,.allocator=allocator};
	const animal = try dog.animal();
	defer allocator.destroy(animal);
	try animal.walk(23);
	
	var cat = Cat{.color="red",.allocator=allocator};
	const animal2 = try cat.animal();
	defer allocator.destroy(animal2);
	try animal2.walk(19);
}