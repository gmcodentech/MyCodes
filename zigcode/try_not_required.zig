const std = @import("std");
pub fn main() void{
	const r = getNo();
	std.debug.print("{any}",.{r});
}

fn getNo() !i32{
	const x:i32 = 105;
	if(x > 100){
		return error.greater_than_100_error;
	}
	
	return x;
}