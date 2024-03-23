const std = @import("std");

pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	
	const allocator = gpa.allocator();

	const Person = struct{
		name:[]const u8,
		age:u8,
	};
	
	const s = 
		\\[
		\\ {"name":"Sachin","age":23},
		\\ {"name":"Rohit","age":32},
		\\ {"name":"Virat","age":29}
		\\]
	;
	
	const parsed = try std.json.parseFromSlice([]Person,allocator,s,.{});
	defer parsed.deinit();
	
	for(parsed.value) |*p|{
		std.debug.print("Name:{s} Age:{d}\n",.{p.*.name,p.*.age});
	}
}