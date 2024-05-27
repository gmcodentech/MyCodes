const std = @import("std");
const fs = std.fs;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
	
	const file = try fs.cwd().openFile("C:/Software/Dotnet/Data/short.tsv", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 0;
	const record_size = 1941;
	
	var lines = try allocator.alloc([]const u8,record_size);
	defer {
		for (lines) |l|{
			allocator.free(l);
		}
		allocator.free(lines);
	}
	
    while (reader.streamUntilDelimiter(writer, '\n', null)) : (line_no += 1) {
		
        defer line.clearRetainingCapacity();
		const trimmed = std.mem.trimRight(u8, line.items, "\r");
		
		lines[line_no] = try allocator.dupe(u8, trimmed);
		if(line_no == record_size-1){
			break;
		}
    } else |err| switch (err) {
        error.EndOfStream => {}, // Continue on
        else => return err, // Propagate error
    }

	// for (lines) |l|{
		// std.debug.print("{s}\n",.{l});
	// }
	
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
		const p1 = try getJson(Movie, allocator, lines[c],"\t");
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
    const st = @typeInfo(T).Struct;
    const obj = try allocator.create(T);
    defer allocator.destroy(obj);

    const field_count = st.fields.len;

    var tokens = try allocator.alloc([]const u8, field_count);
    defer allocator.free(tokens);

    var it = std.mem.split(u8, line, separator);
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
		.Int => try std.fmt.parseInt(data_type, value, 10),
		.Float => try std.fmt.parseFloat(data_type, value),
		.ComptimeInt => try std.fmt.parseInt(data_type, value, 10),
		.ComptimeFloat => try std.fmt.parseFloat(data_type, value),
		else => value,
	};
}


const Movie = struct {
    tconst: []const u8,
    title_type: []const u8,
    primary_title: []const u8,
	original_title: []const u8,
    isadult: u32,
    start_year: u32,
	end_year: u32,
    length: u32,
	genres: []const u8,
};
