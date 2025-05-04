const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
	try read_input();
    for (args) |arg| {
        std.debug.print("{s}\n", .{arg});
    }
}

fn read_input() !void{
	var buf: [20]u8 = undefined;
	std.debug.print("Enter some value",.{});
	var stdin = std.io.getStdIn();
	const input = try stdin.reader().readUntilDelimiterOrEof(&buf,'\n');
	if(input) |line|{
		std.debug.print("Thanks for the value {s}",.{line});
	}
	return;
}
