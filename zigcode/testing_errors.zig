const std = @import("std");


test "add"{
	try std.testing.expect(2+2==4);
}

test "div"{
	try std.testing.expectError(error.divide_by_zero_error,division(1.1,0.0));
}

fn division(f:f32,s:f32) !f32{
	if(s==0.0){
		return error.divide_by_zero_error;
	}
	
	return f/s;
}