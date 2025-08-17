const std = @import("std");
const print = std.debug.print;
const json = std.json;


pub fn main() !void{
	var dbg = std.heap.DebugAllocator(.{}){};
	defer _ = dbg.deinit();
	const allocator = dbg.allocator();
	
	var p = Product{._id="134",.price=34.5};
	const str = try p.documentJson(allocator,.{ .whitespace = .indent_2 });
	defer allocator.free(str);
	print("{s}",.{str});
}

const Product = struct{
	_id:[]const u8,
	price:f32,
		
	fn documentJson(self:Product,allocator:std.mem.Allocator,options: json.StringifyOptions) ![]u8{
		const product = .{
			.price=self.price,
		};
		const res = try json.stringifyAlloc(allocator,product,options);		
		return res;
	}
};