const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	var buf:[20]u8 = undefined;
	const str = try getInputString(&buf);
	if(str) |s|{
		print("{s}",.{s});
	}
}

fn getInputString(buf:[]u8) !?[]const u8{
	const stdin = std.io.getStdIn();
	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		return std.mem.trimRight(u8,line,"\r");
	}
	
	return null;
}