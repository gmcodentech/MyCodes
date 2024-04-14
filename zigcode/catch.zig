const std = @import("std");

pub fn main() !void{
	const r = div(2.3,1.0) catch |err|{
		std.debug.print("Error: {}",.{err});
		return;
	};
	
	std.debug.print("The result is {d}",.{r});
}

fn div(f:f32,s:f32) !f32{
	if(s==0.0){
		return error.divide_by_zero_error;
	}
	
	return f/s;
	//This is a small comment
}
	
