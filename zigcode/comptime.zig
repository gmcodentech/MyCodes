const std = @import("std");

fn addTwo(comptime T: type, first:T,second:T) T{
	return first + second;
}

pub fn main() !void{

	
	//var buf2:[15]u8 = undefined;
	
	std.debug.print("Enter two nos: \n",.{});
	
	const fno = getInput(u32) catch 0;
	const sno = getInput(u32) catch 0;	
	std.debug.print("{d}\n",.{addTwo(u32,fno,sno)});	
	
	std.debug.print("{d}",.{addTwo(u32,2.3,0.2)});
}

fn getInput(comptime T:type) !T{
	const stdin = std.io.getStdIn();	
	var buf:[15]u8 = undefined;
	var userInput: T = undefined;
	if(try stdin.reader().readUntilDelimiterOrEof(&buf,'\n')) |line|{
		const input = std.mem.trimRight(u8, line, "\r");	
		if(@TypeOf(T) == @TypeOf(f32)){
			userInput = try std.fmt.parseFloat(f32,input);
		}else{
			userInput = try std.fmt.parseInt(u32,input,10);

		}
	}
	
	return @as(T,userInput); 
}