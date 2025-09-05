const std = @import("std");

pub fn main() !void{
	try std.fs.File.stdout().writeAll("Enter your name: ");
	
	//buffer for reading
	var stdin_buf:[20]u8 = undefined;
	var stdin_reader = std.fs.File.stdin().reader(&stdin_buf);
	const stdin = &stdin_reader.interface;
	
	//read the line untile newline
	const line = try stdin.takeDelimiterExclusive('\n');
	
	//buffer for writing
	var stdout_buf:[20]u8 = undefined;
	var stdout_writer = std.fs.File.stdout().writer(&stdout_buf);
	const stdout = &stdout_writer.interface;
	
	//print the output
	try std.Io.Writer.print(stdout,"Hello , {s}",.{line});
	try stdout.flush();
}