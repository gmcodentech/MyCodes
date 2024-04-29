const std = @import("std");
    
const Animal = struct{
	walkfn : *const fn(*const Animal,u32) void,
	fn walk(self:*const Animal,speed:u32) void{
		self.walkfn(self,speed);
	}
};
    
const Dog = struct{
	animal:Animal = Animal{.walkfn = walk},
	fn walk(_:*const Animal,speed:u32) void{
		std.debug.print("dog is walking with {d}\n",.{speed});
	}
};

const Cat = struct{
	animal:Animal = Animal{.walkfn = walk},
	age:u8,
	fn walk(animal:*const Animal,speed:u32) void{
		const self = @as(*Cat,@constCast(animal));
		std.debug.print("cat {d} is walking with {d}\n",.{self.age,speed});
	}
};

    
pub fn main() void{
	const cat = (Cat{.age=9}).animal;
	const animals:[2]Animal = [_]Animal{(Dog{}).animal,cat};
	for (animals) |animal|{
		animal.walk(12);
	}
}