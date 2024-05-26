const std = @import("std");
   
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	const st = @typeInfo(Book).Struct;
	var obj = try allocator.create(Book);
	defer allocator.destroy(obj);
	
	const pair = struct{type:[]const u8, value:[]const u8};
	var maps = std.StringHashMap(pair).init(allocator);
	defer maps.deinit();
	
	try maps.put("title",.{.type="string",.value=".NET"});
	try maps.put("price",.{.type="float",.value="2.4"});
	
	
	inline for (st.fields) |field|{
	  		std.debug.print("{s}",.{maps.get(field.name).?.type});
			if(std.mem.eql(u8,maps.get(field.name).?.type,"float")){
				std.debug.print("{s}",.{maps.get(field.name).?.type});
				@field(obj,field.name)="23.5";
			}
			else if(std.mem.eql(u8,maps.get(field.name).?.type,"string")){
				//@field(obj,field.name)=".NET";
			}
		}
	
	
	std.debug.print("{s} {d}",.{obj.title,obj.price});
}
  
const Book = struct{
	title:[]const u8,
	price:[]const u8,
};
----------------------------------------------------------------------------------------------
const std = @import("std");
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	try getJson(Product,allocator,"Milk,44.5,300");
}
 
fn getJson(comptime T:type,allocator:std.mem.Allocator,line:[]const u8) !void{
	const st = @typeInfo(T).Struct;
	const obj = try allocator.create(T);
	defer allocator.destroy(obj);
	 
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
	std.debug.print("{d}",.{tokens.len});
 	i = 0;
	inline for (st.fields) |field|{
		@field(obj,field.name)=try getValue(field.type,tokens[i]);
		i += 1;
	}
	
	std.debug.print("{any}",.{obj});
}

fn getValue(comptime data_type:type,value:[]const u8) !data_type{
	if(data_type == u32){
		return try std.fmt.parseInt(data_type,value,10);
	}else if(data_type == f32){
		return try std.fmt.parseFloat(data_type,value);
	}
	
	return value;
}
 
const Product = struct{
	name:[]const u8,
	price:f32,
	units:u32,
};
