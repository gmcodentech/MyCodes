const std = @import("std");
const HttpClient = @import("HttpClient.zig").HttpClient;

pub fn DB(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        database_name: []const u8,
        client: HttpClient,
        base_url: []const u8 = "http://localhost:5984",

        var arena: std.heap.ArenaAllocator = undefined;
        const Self = @This();

        const Value = struct {
            rev: []const u8,
        };

        const Row = struct {
            id: []const u8,
            key: []const u8,
            value: Value,
            doc: ?T,
        }; 

        const CouchDBResponse = struct {
            total_rows: u32,
            offset: u32,
            rows: []const Row,
        };

        const RecordCreateResponse = struct {
            ok: bool,
            id: []u8,
            rev: []u8,
        };	

		const SearchResult = struct{
			docs:[]T,
			bookmark:[]u8,
		};
		
		

        const UUIDResponse = struct { uuids: [][]u8 };
		
        pub fn init(allocator: std.mem.Allocator, database_name: []const u8,username:[]const u8,password:[]const u8) Self {
            arena = std.heap.ArenaAllocator.init(allocator);
            const arenaAllocator = arena.allocator();
            
			const http_client = HttpClient.init(arenaAllocator, username, password);
            return Self{ .allocator = arenaAllocator, .database_name = database_name, .client = http_client };
        }
        pub fn deinit(self: *Self) void {
            self.client.deinit();
            arena.deinit();
        }
		
		pub fn getDbMetadata(self:*Self) !Info{
			const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}", .{ self.base_url, self.database_name });
			defer  self.allocator.free(url);
			
            const metadata_json = try self.client.send(.GET, url, "");
			defer self.allocator.free(metadata_json);
			
			const parsed_metadata = try std.json.parseFromSlice(Info, self.allocator, metadata_json, .{ .ignore_unknown_fields = true });
            return parsed_metadata.value;
		}
		
		pub fn createDb(self:*Self) !bool{
			const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}", .{ self.base_url, self.database_name });
            defer self.allocator.free(url);
            
			_ = try self.client.send(.PUT, url, "");
			return true;
		}
		
		pub fn checkForDb(self:*Self,db:[]const u8) !bool{
			const url = try std.fmt.allocPrint(self.allocator, "{s}/_all_dbs", .{ self.base_url });
            defer self.allocator.free(url);
			
			const resp_json = try self.client.send(.GET, url, "");
            const db_list = try std.json.parseFromSlice([][]u8, self.allocator, resp_json, .{ .ignore_unknown_fields = true });
            defer self.allocator.free(resp_json);
			
			var exists:bool = false;
			for(db_list.value) |d|{
				if(std.mem.eql(u8,d,db)){
					exists = true;
					break;
				}
			}
			
            return exists;
			
		}

        fn save(self: *Self, url: []const u8, method: std.http.Method, json: []u8) !RecordCreateResponse {
            const response_json = try self.client.send(method, url, json);
			defer self.allocator.free(response_json);
			
            const response = try std.json.parseFromSlice(RecordCreateResponse, self.allocator, response_json, .{ .ignore_unknown_fields = true });
            return response.value;
        }

        pub fn create(self: *Self, item: anytype) !RecordCreateResponse {
            const json = try std.json.stringifyAlloc(self.allocator, item, .{ .whitespace = .indent_2 });
			defer self.allocator.free(json);
			
            const uuid = try getUuid(self.allocator, &self.client, self.base_url);
            const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}/{s}:{s}", .{ self.base_url, self.database_name,item.type, uuid });
			defer self.allocator.free(url);            
           
            return save(self, url, .PUT, json);
        }
		
		pub fn search(self: *Self, mangoQuery: anytype) ![]T {
			
            const json = try std.json.stringifyAlloc(self.allocator, mangoQuery, .{ .whitespace = .indent_2 });
            const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}/_find", .{ self.base_url, self.database_name });

            defer self.allocator.free(url);
            defer self.allocator.free(json);
			
			const result_json = try self.client.send(.POST, url, json);
            const parsed_result = try std.json.parseFromSlice(SearchResult, self.allocator, result_json, .{ .ignore_unknown_fields = true });
			
            return parsed_result.value.docs;
        }

        pub fn update(self: *Self, item: T) !RecordCreateResponse {
            const json = try std.json.stringifyAlloc(self.allocator, item, .{ .whitespace = .indent_2 });
			defer self.allocator.free(json);
            
			const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}/{s}", .{ self.base_url, self.database_name, item._id });
            defer self.allocator.free(url);
            
			return save(self, url, .PUT, json);
        }
        pub fn delete(self: *Self, item: T) !RecordCreateResponse {
            const json = try std.json.stringifyAlloc(self.allocator, item, .{ .whitespace = .indent_2 });
            defer self.allocator.free(json);
			
			const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}/{s}?rev={s}", .{ self.base_url, self.database_name, item._id, item._rev });
			defer self.allocator.free(url);
            
			return save(self, url, .DELETE, json);
        }

        fn getUuid(allocator: std.mem.Allocator, client: *HttpClient, base_url: []const u8) ![]u8 {
            const url = try std.fmt.allocPrint(allocator, "{s}/_uuids", .{base_url});
            defer allocator.free(url);
            
			const uuids_json = try client.send(.GET, url, "");
            defer allocator.free(uuids_json);
            
			const parsed_product = try std.json.parseFromSlice(UUIDResponse, allocator, uuids_json, .{ .ignore_unknown_fields = true });
            return parsed_product.value.uuids[0];
        }

        pub fn getById(self: *Self, id: []u8) !T {
            const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}/{s}", .{ self.base_url, self.database_name, id });
			defer  self.allocator.free(url);
			
            const product_json = try self.client.send(.GET, url, "");
			defer self.allocator.free(product_json);
			
			const parsed_product = try std.json.parseFromSlice(T, self.allocator, product_json, .{ .ignore_unknown_fields = true });
            return parsed_product.value;
        }

        pub fn getList(self: *Self,count:u64) ![]T {
            const url = try std.fmt.allocPrint(self.allocator, "{s}/{s}/_all_docs?include_docs=true&limit={d}", 
			.{ self.base_url, self.database_name, count });
            defer self.allocator.free(url);
			
  		    const product_json = try self.client.send(.GET, url, "");
            defer self.allocator.free(product_json);

            const parsed_product = try std.json.parseFromSlice(CouchDBResponse, self.allocator, product_json, .{ .ignore_unknown_fields = true });
            const response = parsed_product.value;
            var list = std.ArrayList(T).init(self.allocator);
            errdefer list.deinit();
            
			for (response.rows) |row| {
				if(row.doc) |d|{
					try list.append(d);
				}
            }
            const items = try list.toOwnedSlice();
            return items;
        }
    };
}

pub const Info = struct {
			instance_start_time: []const u8,
			db_name: []const u8,
			purge_seq: []const u8,
			update_seq: []const u8,
			sizes: struct {
				file: usize,
				external: usize,
				active: usize,
			},
			props: std.json.Value,
			doc_del_count: usize,
			doc_count: usize,
			disk_format_version: usize,
			compact_running: bool,
			cluster: struct {
				q: usize,
				n: usize,
				w: usize,
				r: usize,
			},
};
