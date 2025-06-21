const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var dog = Dog{};
	dog.animal().eat();
	print("\n",.{});
	var cat = Cat{};
	cat.animal().eat();
	print("\n",.{});
	var horse = Horse{};
	const horseAnimal = horse.animal();
	horseAnimal.eat();
	horseAnimal.walk();
	
}
const Horse = struct {
	fn animal(self:*Horse) Animal{
		return Animal{.ptr=self,.eatFn=eat,.walkFn=walk};
	}
	
	fn eat(self:*anyopaque) void{
		_=self;
		print("Horse is eating...",.{});
	}
	
	fn walk(self:*anyopaque) void{
		_ = self;
		print("\nHorse is walking...",.{});
	}
};

const Cat = struct {
	fn animal(self:*Cat) Animal {
		return Animal{.ptr=self,.eatFn=eat,.walkFn=walk};
	}
	fn eat(self:*anyopaque) void {
		_=self;
		print("Cat is eating...",.{});
	}
	fn walk(self:*anyopaque) void{
		_ = self;
		print("\nCat is walking...",.{});
	}

};
const Dog = struct {	
	fn animal(self:*Dog) Animal{
		return Animal{.ptr=self,.eatFn=eat,.walkFn=walk};
	}
	fn eat(self:*anyopaque) void {
		_=self;
		print("Dog is eating...",.{});
	}
	fn walk(self:*anyopaque) void{
		_ = self;
		print("\nDog is walking...",.{});
	}

};

const Animal = struct {
	ptr:*anyopaque,
	eatFn: *const fn(ptr:*anyopaque) void,
	walkFn: *const fn(ptr:*anyopaque) void,
	fn eat(animal:Animal) void {
		animal.eatFn(animal.ptr);
	}
	fn walk(animal:Animal) void{
		animal.walkFn(animal.ptr);
	}
	
};

