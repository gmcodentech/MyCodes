const std = @import("std");
const print = std.debug.print;

pub fn main() void{
	var arr = [_]i32{23,4,5};
	change(&arr);
	print("{any}",.{arr});
}

fn change(arr:[]i32) void{
	arr[1]=757;
}