const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	print("Enter a no: ",.{});
	const no = try read_int();
	print("Thanks for entering {d}",.{no});
	print("\nEnter another no: ",.{});
	const no1 = try read_int();
	print("Thanks for entering another number {d}",.{no1});
}


fn read_int() !u64 {
	var buf:[100]u8 = undefined;
	const stdin = std.io.getStdIn();
	const line = try stdin.reader().readUntilDelimiterOrEof(&buf,'\n');
	if(line) |ln|{
		const trimmedLine = std.mem.trimRight(u8,ln,"\r");
		return try std.fmt.parseInt(u64,trimmedLine,10);
	}
	
	return 0;
}