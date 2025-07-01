const std = @import("std");
const print = std.debug.print;

pub fn main() void {
	var typeOfAnimal = "EDog";
	const animal = .{.AnimalType=std.meta.stringToEnum(AnimalType,typeOfAnimal),.name="Tomy",.age=3};
	print("{s} {d}\n",.{animal.name,animal.age});
	typeOfAnimal = "EHor";
	const animal2 = .{.AnimalType=std.meta.stringToEnum(AnimalType,typeOfAnimal),.name="Dyno",.age=12};
	print("{s} {d}\n",.{animal2.name,animal2.age});
}

const Dog = struct{
	type:AnimalType,
	name:[]const u8,
	age:u32,
};
const Cat = struct {
	type:AnimalType,
	name:[]const u8,
	age:u32,
};

const Horse = struct {type:AnimalType,name:[]const u8, age:u32};
const AnimalType = enum {
	EDog,
	ECat,
	EHorse,
};