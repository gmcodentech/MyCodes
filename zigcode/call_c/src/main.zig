const std = @import("std");

const c = @cImport({
		@cInclude("math.h");
	});
	
pub fn main() !void{
	var buf:[20]u8 = undefined;
	std.debug.print("Enter a no: ",.{});
	const a = try read_input(&buf);
	// std.debug.print("Enter b: ",.{});
	// const b = try read_input(&buf);
	// const result = c.add_two(a,b);
	const result = c.get_total(a);
	std.debug.print("The result from c in {d}",.{result});
}

fn read_input(buf:[]u8) !i32{
	
	const stdin = std.io.getStdIn();
	//defer stdin.close();
	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const no = std.mem.trimRight(u8, line, "\r");
		return std.fmt.parseInt(i32,no,10);
	}
	
	return 0;
}