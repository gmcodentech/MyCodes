const std = @import("std");
pub fn main() !void{
	var buf:[20]u8 = undefined;
	var stdout_writer = std.fs.File.stdout().writer(&buf);
	const stdout = &stdout_writer.interface;
	
	try std.Io.Writer.print(stdout,"Hello world {d}",.{45});
	try stdout.flush();
}