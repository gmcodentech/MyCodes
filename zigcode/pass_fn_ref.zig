const std = @import("std");
const print = std.debug.print;

pub fn main() void{
	const list = [_]u32{1,2,3,4,5};
	
	print("{d}",.{total(&list,even)});
	print("\n{d}",.{total(&list,odd)});
	print("\n{d}",.{total(&list,lessThan4)});

}

fn lessThan4(n:u32) bool {
	return n < 4;
}

fn even(n:u32)bool{
	return @mod(n,2) == 0;
}

fn odd(n:u32)bool{
	return @mod(n,2) == 1;
}

fn total(list:[]const u32,func:*const fn(n:u32) bool)u32{
	var sum:u32 = 0;
	for(list)|n|{
		if(func(n)){
			sum +=n;
		}
	}
	return sum;
}