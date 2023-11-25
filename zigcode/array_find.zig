const std = @import("std");
 
pub fn main() void{
	var arr:[1000]u64 = undefined;
	 
	for (0..1000) |indx|{
		arr[indx]=@as(u64,indx)+@as(u64,9);
	} 
	 
	const position:usize = 345;
	//first method using array index
	//std.debug.print("{d}",.{arr[position]}); //this is fast fetched using address of the array location
	
	//second method
	for (0..1000) |p|{
		if(p==position){
			std.debug.print("{d}",.{arr[position]});
		}
	}
}