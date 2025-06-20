const std = @import("std");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
	
	var lines = try allocator.alloc([]const u8,4);
	defer allocator.free(lines);
	lines[0]="Milk,44.5,300,1";
	lines[1]="Sugar,53.3,90,0";
	lines[2]="Tea,5.3,190,1";
	lines[3]="Coffee,8.5,58,1";
	
	
	var json_map = std.StringHashMap([]const u8).init(allocator);
	defer {
		
		var itk = json_map.keyIterator();
		while (itk.next()) |value_ptr| {
			allocator.free(value_ptr.*);
		}
		var it = json_map.valueIterator();
		while (it.next()) |value_ptr| {
			allocator.free(value_ptr.*);
		}
		json_map.deinit();
	}
	
	for (0..lines.len) |c|{
		const p1 = try getJson(Product, allocator, lines[c],",");
		var buf: [10]u8 = undefined;
		const str = try std.fmt.bufPrint(&buf, "{d}", .{c+1});
		try json_map.put(try allocator.dupe(u8,str), p1);
	}
	
	for (0..lines.len) |c|{
		var buf: [10]u8 = undefined;
		const str = try std.fmt.bufPrint(&buf, "{d}", .{c+1});
		std.debug.print("{s}\n", .{json_map.get(str).?});
	}
    
}

fn CSVToJson(comptime T:type) type{
	return struct{
		allocator:std.mem.Allocator,
		maps:std.AutoHashMap(usize,[]const u8) = undefined,
		
		const Self = @This();
		var i:usize = 1;
		fn init(allocator:std.mem.Allocator) !*Self{
			const CTJ = try allocator.create(Self);
			CTJ.* = Self{.allocator = allocator,.maps = std.AutoHashMap(usize,[]const u8).init(allocator)};
			return CTJ;
		}		
		
		fn deinit(self:*Self) void{
			self.maps.deinit();
			self.allocator.destroy(self);
		}
		
		fn convert(self:*Self,line:[]const u8) !void{
			const json_string = try getJson(T, self.allocator, line);
			defer self.allocator.free(json_string);
			try self.maps.put(i, json_string);
			i += 1;
		}
		
		fn get(self:*Self,index:usize) []const u8{
			if(self.maps.get(index)) |v|
			std.debug.print("{s}",.{v});
			return self.maps.get(index).?;
		}
		
	};
}



fn getJson(comptime T: type, allocator: std.mem.Allocator, line: []const u8,separator:[]const u8) ![]const u8 {
    const st = @typeInfo(T).@"struct";
    const obj = try allocator.create(T);
    defer allocator.destroy(obj);

    const field_count = st.fields.len;

    var tokens = try allocator.alloc([]const u8, field_count);
    defer allocator.free(tokens);

    var it = std.mem.splitSequence(u8, line, separator);
    var i: usize = 0;
    while (it.next()) |p| {
        tokens[i] = p;
        i += 1;
    }
    i = 0;
    inline for (st.fields) |field| {
        @field(obj, field.name) = try getValue(field.type, tokens[i]);
        i += 1;
    }

    const json_str = try std.json.stringifyAlloc(allocator, obj, .{});
    return json_str;
}

fn getValue(comptime data_type: type, value: []const u8) !data_type {

	return switch(@typeInfo(data_type)){
		.int => try std.fmt.parseInt(data_type, value, 10),
		.float => try std.fmt.parseFloat(data_type, value),
		.comptime_int => try std.fmt.parseInt(data_type, value, 10),
		.comptime_float => try std.fmt.parseFloat(data_type, value),
		else => value,
	};
}

const Product = struct {
    name: []const u8,
    price: f32,
    units: u32,
	in_stock:[]const u8,
};
