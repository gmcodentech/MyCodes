const std = @import("std");
const print = std.debug.print;
const http = std.http;
pub fn main() !void{
	var dbg = std.heap.DebugAllocator(.{}){};
	defer _ = dbg.deinit(); 
	const allocator = dbg.allocator();

	const rice = try allocator.dupe(u8,"Rice");
	defer allocator.free(rice);
	const id = try allocator.dupe(u8,"100");
	defer allocator.free(id);
	
	var db = DB(Product).init(allocator);
	defer db.deinit();
	
	const saved_response = try db.save(.{.name=rice,.price=234.5,.units=1009});
	print("\nok:{} id:{s} rev:{s}",.{saved_response.ok,saved_response.id,saved_response.rev});

	const products = try db.getList();
	for(products) |p|{
		print("\n{s} {d} {s} {d}",.{p.name,p.price,p._id,p.units});
	}
	 const item_id = try allocator.dupe(u8,"9170c682dd835642f5bb7521a800347d");
	 defer allocator.free(item_id);
	 const product = try db.getById(item_id);
	 print("\n{s} {d} {s}",.{product._id,product.price,product.name});	 

}



fn DB(comptime T:type) type{
	return struct{
		allocator:std.mem.Allocator,
		var arena: std.heap.ArenaAllocator = undefined;
		const Self = @This();
		
		const Value = struct {
			rev: []const u8,
		};

		const Row = struct {
			id: []const u8,
			key: []const u8,
			value: Value,
			doc: T,
		};

		const CouchDBResponse = struct {
			total_rows: u32,
			offset: u32,
			rows: []const Row,
		};

		const RecordCreateResponse = struct{
			ok:bool,
			id:[]u8,
			rev:[]u8,
		};

		const UUIDResponse = struct{
			uuids:[][]u8
		};
		fn init(allocator:std.mem.Allocator)Self{
			arena = std.heap.ArenaAllocator.init(allocator);
			const arenaAllocator = arena.allocator();
			return Self{.allocator=arenaAllocator};
		}
		fn deinit(self:*Self) void{
			_ = self;
			arena.deinit();
		}
		fn save(self:*Self,item:anytype) !RecordCreateResponse{
			const json = try std.json.stringifyAlloc(self.allocator,item,.{.whitespace=.indent_2});
			const uuid = try getUuid(self.allocator);
			const url = try std.fmt.allocPrint(self.allocator, "http://admin:admin@localhost:5984/catalog/{s}", .{uuid});
			defer self.allocator.free(url);
			var client = HttpClient.init(url,"admin","admin");
			const response_json = try client.put(self.allocator,json);	
			const response = try std.json.parseFromSlice(RecordCreateResponse,self.allocator,response_json,.{.ignore_unknown_fields=true});
			self.allocator.free(json);
			self.allocator.free(response_json);
			return response.value;
		}
		
		fn getUuid(allocator:std.mem.Allocator) ![]u8{
			const url="http://admin:admin@localhost:5984/_uuids";
			var client = HttpClient.init(url,"admin","admin");
			const uuids_json = try client.get(allocator);
			defer allocator.free(uuids_json);
			const parsed_product = try std.json.parseFromSlice(UUIDResponse,allocator,uuids_json,.{.ignore_unknown_fields=true});
			return parsed_product.value.uuids[0];
		}
		
		fn getById(self:*Self,id:[]u8) !T{			
			const url = try std.fmt.allocPrint(self.allocator, "http://admin:admin@localhost:5984/catalog/{s}", .{id});
			var client = HttpClient.init(url,"admin","admin");
			const product_json = try client.get(self.allocator);			
			const parsed_product = try std.json.parseFromSlice(T,self.allocator,product_json,.{.ignore_unknown_fields=true});
			self.allocator.free(url);
			self.allocator.free(product_json);
			return parsed_product.value;
		}
		
		fn getList(self:*Self) ![]T{
			var client = HttpClient.init("http://admin:admin@localhost:5984/catalog/_all_docs?include_docs=true","admin","admin");
			const product_json = try client.get(self.allocator);
			defer self.allocator.free(product_json);

			const parsed_product = try std.json.parseFromSlice(CouchDBResponse,self.allocator,product_json,.{.ignore_unknown_fields=true});
			const response = parsed_product.value;
			var list = std.ArrayList(T).init(self.allocator);
			errdefer list.deinit();
			for(response.rows) |row|{
				try list.append(row.doc);
			}
			const items = try list.toOwnedSlice();
			return items;
		}
	};
}

const HttpClient = struct{
	input_url: []const u8,
	user:[]const u8,
	password:[]const u8,
	const Self = @This();
	
	fn init(input_url:[]const u8,user:[]const u8, pass:[]const u8) HttpClient{
		return HttpClient{.input_url=input_url,.user=user,.password=pass};
	}
	fn get(self:*Self,allocator:std.mem.Allocator) ![]u8{
		var uri = try std.Uri.parse(self.input_url);
		uri.user = .{ .raw = self.user };
		uri.password = .{ .raw = self.password };

		const buf = try allocator.alloc(u8, 1024 * 1024 * 4);
		defer allocator.free(buf);

		var client = http.Client{ .allocator = allocator };
		defer client.deinit();

		var req = try client.open(.GET, uri, .{
			.server_header_buffer = buf,
		});
		defer req.deinit();

		try req.send();
		try req.finish();
		try req.wait();

		var rdr = req.reader();
		const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
		return body;
	}
	
	fn put(self:*Self,allocator:std.mem.Allocator,payload:[]u8) ![]u8{
		var uri = try std.Uri.parse(self.input_url);
		uri.user = .{ .raw = self.user };
		uri.password = .{ .raw = self.password };
		var client = http.Client{ .allocator = allocator };
		defer client.deinit();
		var buf: [1024]u8 = undefined;

		var req = try client.open(.PUT, uri, .{ .server_header_buffer = &buf });
		defer req.deinit();

		req.transfer_encoding = .{ .content_length = payload.len };
		try req.send();
		var wtr = req.writer();
		try wtr.writeAll(payload);
		try req.finish();
		try req.wait();
		var rdr = req.reader();
		const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
		return body;
	}
};

const User = struct{
	_id:i32,
	power:u32,
};

const Product = struct{
	_id: []u8,
    _rev: []u8,
	name: []u8,
	price: f32,
	units:i32=0,
};

