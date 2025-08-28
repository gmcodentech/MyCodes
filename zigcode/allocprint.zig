const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	const name = "something";
	const alc = std.heap.page_allocator;
	const gre = try getGreeting(alc,name);
	defer alc.free(gre);
	print("{s}",.{gre});
}

fn getGreeting(allocator:std.mem.Allocator,name:[]const u8) ![]u8{
	const greeting = try std.fmt.allocPrint(allocator,"Hello {s}",.{name});
	return greeting;
}