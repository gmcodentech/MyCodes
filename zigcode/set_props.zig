const std = @import("std");
   
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	const st = @typeInfo(Book).Struct;
	var obj = try allocator.create(Book);
	defer allocator.destroy(obj);
	
	inline for(st.fields) |field|{
	  		if(f32 == field.type){
				@field(obj,field.name)=1.6;
			}
			else if([]const u8 == field.type){
				@field(obj,field.name)=".NET";
			}
	}
	  
	std.debug.print("{s} {d}",.{obj.title,obj.price});
}
  
const Book = struct{
	title:[]const u8,
	price:f32,
};