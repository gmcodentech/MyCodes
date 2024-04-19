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
	fn walk(_:*const Animal,speed:u32) void{
		std.debug.print("cat is walking with {d}\n",.{speed});
	}
};

    
pub fn main() void{
	const animals:[2]Animal = [_]Animal{(Dog{}).animal,(Cat{}).animal};
	for (animals) |animal|{
		animal.walk(12);
	}
}