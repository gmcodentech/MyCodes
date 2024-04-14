const std = @import("std");

	
pub fn main() !void{
	var buf:[20]u8 = undefined;
	std.debug.print("Enter a no: ",.{});
	const a = try read_input(&buf);
	var total:u64 = 0;
	for (0..(a+1)) |v|{
		total += v;
	}
	std.debug.print("{d}",.{total});
}

fn read_input(buf:[]u8) !u64{
	
	const stdin = std.io.getStdIn();
	//defer stdin.close();
	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const no = std.mem.trimRight(u8, line, "\r");
		return std.fmt.parseInt(u64,no,10);
	}
	
	return 0;
}