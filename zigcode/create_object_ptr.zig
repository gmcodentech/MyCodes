const std = @import("std");
const Person = struct{
	name:[]const u8,
	salary:f32,
	allocator:std.mem.Allocator,
	const Self = @This();
	fn init(allocator:std.mem.Allocator,name:[]const u8,sal:f32) !*Self{
		const person = try allocator.create(Self);
		person.* = .{.name = name,.salary=sal, .allocator=allocator};
		return person;
	}
	fn deinit(self:*Self) void {
		self.allocator.destroy(self);
	}
	
	fn display(self:*Self) void {
		std.debug.print("name: {s} salary: {d}",.{self.name,self.salary});
	}
};

pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	const p = try Person.init(allocator,"John",3422.4);
	defer p.deinit();
	
	p.display();
}

