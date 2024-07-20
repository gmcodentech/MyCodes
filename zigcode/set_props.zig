const std = @import("std");
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	const obj = try getObject(Product,allocator,"Milk,44.5,300");
	defer allocator.destroy(obj);
	std.debug.print("{s} {d} {d}\n",.{obj.name,obj.price,obj.units});
	  
	const obj2 = try getObject(Point,allocator,"2,3");
	defer allocator.destroy(obj2);
	std.debug.print("{d} {d}",.{obj2.x,obj2.y});
	  
 
}
  
const Point = struct{
	x:i32,
	y:i32
};
   
fn getObject(comptime T:type,allocator:std.mem.Allocator,line:[]const u8) !*T{
	const st = @typeInfo(T).Struct;
	const obj = try allocator.create(T);
	  
	   
	const field_count = st.fields.len;
	   
	var tokens = try allocator.alloc([]const u8,field_count );
	defer allocator.free(tokens);
	   
	var it = std.mem.split(u8,line,",");
	var i:usize = 0;
	while(it.next())|p|{
		//std.debug.print("{s}",.{p});
		tokens[i]=p;
		i += 1;
	}
	//std.debug.print("{d}",.{tokens.len});
 	i = 0;
	inline for (st.fields) |field|{
		@field(obj,field.name)=try getValue(field.type,tokens[i]);
		i += 1;
	}
	  
	//std.debug.print("{s} {d} {d}",.{obj.name,obj.price,obj.units});
	return obj;
}
  
fn getValue(comptime data_type:type,value:[]const u8) !data_type{
	const typeInfo = @typeInfo(data_type);
	switch(typeInfo){
		.Int => return try std.fmt.parseInt(data_type,value,10),
		.Float => return try std.fmt.parseFloat(data_type,value),
		else => return value
	}
}
   
const Product = struct{
	name:[]const u8,
	price:f32,
	units:u32,
};