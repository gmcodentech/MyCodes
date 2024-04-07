const std = @import("std");

fn work(name:[]const u8) void {
	std.time.sleep(2 * std.time.ns_per_s);
	std.debug.print("\nwork completed by {s}",.{name});
}
pub fn main() !void {
	const t1 = try std.Thread.spawn(.{},work,.{"Jhon"});
	t1.join();
	const t2 = try std.Thread.spawn(.{},work,.{"Scott"});
	t2.join();
	const t3 = try std.Thread.spawn(.{},work,.{"Tom"});

	t3.join();	
	
	std.debug.print("\ndone",.{});
}