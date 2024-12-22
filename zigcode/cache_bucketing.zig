const std = @import("std");
const fs = std.fs;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const ltoc = try ZDSV(Movie).init(allocator);
    defer ltoc.deinit();

    const objects = try ltoc.save("C:\\Software\\Dotnet\\Data\\shorthash.txt", "#", true, 0,"tconst");
	_ = objects;
    // std.debug.print("Total movies {d}\n", .{objects.items.len});
    // var inc: usize = 0;
    // for (objects.items) |object| {
        // std.debug.print("{s:12}|{d:5}|{d:5}|{s:80}|{s:30}\n", .{ object.tconst, object.start_year, object.run_len, object.primary_title, object.genres });
        // inc += 1;
        // if (inc == 20) {
            // break;
        // }
    // }
	
	std.debug.print("Bucketed movie count: {d}\n",.{ltoc.getBucketedItemCount()});
	
	var buf:[20]u8 = undefined;
	
	var searchText:[]const u8 = undefined;
	while(!std.mem.eql(u8,searchText,"exit")){
	std.debug.print("Enter search text: ",.{});
	searchText = try read_input(&buf);
	if(try ltoc.searchItem(searchText)) |object|{
		
		//std.debug.print("Searched {s}\n",.{search});
		std.debug.print("{s:12}|{d:5}|{d:5}|{s:12}|{s:12}\n", .{ object.tconst, object.start_year, object.run_len, object.primary_title, object.genres });
	}
	}

    std.debug.print("completed", .{});
}

fn read_input(buf:[]u8) ![]const u8{
	
	const stdin = std.io.getStdIn();

	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const trimmedText = std.mem.trimRight(u8, line, "\r");
		return trimmedText;
	}
	
	return "";
}

const Movie = struct { tconst: []const u8, title_type: []const u8, primary_title: []const u8, original_title: []const u8, is_adult: u1, start_year: u16, end_year: u16, run_len: u16, genres: []const u8 };
pub fn ZDSV(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        var arena: std.heap.ArenaAllocator = undefined;
		
		var factory:*bucketFactory(T) = undefined;
		var count:usize = 0;

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) !*Self {			
            arena = std.heap.ArenaAllocator.init(allocator);
            const arenaAllocator = arena.allocator();
			factory = try bucketFactory(T).init(allocator, 1000);
            const ltoc = try arenaAllocator.create(Self);
            ltoc.* = Self{ .allocator = arenaAllocator };
            return ltoc;
        }

        pub fn save(self: *Self, input_file: []const u8, sep: []const u8, header: bool, n: usize,col:[]const u8) !*std.ArrayList(T) {
            var objects = std.ArrayList(T).init(self.allocator);
			_ = col;
            //Read lines
            const file = try fs.cwd().openFile(input_file, .{});
            defer file.close();

            var buf_reader = std.io.bufferedReader(file.reader());
            const reader = buf_reader.reader();

            var line = std.ArrayList(u8).init(self.allocator);

            const writer = line.writer();
            var header_line_processed: bool = !header;
            var counter: usize = 0;
			
			

            while (reader.streamUntilDelimiter(writer, '\n', null)) : (counter += 1) {
                defer line.clearRetainingCapacity();
                if (!header_line_processed) {
                    header_line_processed = true;
                    continue;
                }
                const str = try self.allocator.dupe(u8, line.items);
                const obj = try getObject(self.allocator, str, sep);

                //try objects.append(obj);
				
				try factory.addItem(@field(obj,"tconst"),obj);
				count += 1;

                if (n != 0 and counter == n) {
                    break;
                }
            } else |err| switch (err) {
                error.EndOfStream => {},
                else => return err,
            }

            return &objects;
        }
		
		fn searchItem(self:*Self,item:[]const u8) !?T{
			_=self;
			return try factory.findItem(item);
		}
		
		fn getBucketedItemCount(self:*Self) usize{
			_ = self;
			return count;
		}

        fn getObject(allocator: std.mem.Allocator, line: []const u8, sep: []const u8) !T {
            const st = @typeInfo(T).Struct;
            const obj = try allocator.create(T);
            const field_count = st.fields.len;

            var tokens = try allocator.alloc([]const u8, field_count);
            var it = std.mem.split(u8, line, sep);
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

            return obj.*;
        }

        pub fn deinit(self: *Self) void {
			factory.deinit();
            self.allocator.destroy(self);
            arena.deinit();
        }

        fn getValue(comptime data_type: type, value: []const u8) !data_type {
            const dsv = std.mem.trimLeft(u8,std.mem.trimRight(u8, value, "\r"),"");
            const typeInfo = @typeInfo(data_type);
            switch (typeInfo) {
                .Int => return try std.fmt.parseInt(data_type, dsv, 10),
                .Float => return try std.fmt.parseFloat(data_type, dsv),
                else => return dsv,
            }
        }
    };
}



fn bucketFactory(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        buckets: std.ArrayList(std.ArrayList(T)) = undefined,
        maximumBuckets: u32 = 10,

        var hashmap: std.AutoHashMap(usize, usize) = undefined;

        const Self = @This();
        fn init(allocator: std.mem.Allocator, maxBuckets: u32) !*Self {
            hashmap = std.AutoHashMap(usize, usize).init(allocator);

            const factory = try allocator.create(Self);
            const buckets = std.ArrayList(std.ArrayList(T)).init(allocator);
            factory.* = Self{ .buckets = buckets, .maximumBuckets = maxBuckets, .allocator = allocator };
            return factory;
        }

        fn getHashPosition(allocator: std.mem.Allocator, element: []const u8) !u64 {
            var hasher = HexHash(std.crypto.hash.sha2.Sha384).init(allocator);
            defer hasher.deinit();
            try hasher.hex_hash(element);
            const hash = hashSum(hasher.hex_digest);
            return hash;
        }

        fn addItem(self: *Self,bucket_col:[]const u8, element: T) !void {
            const hash = try getHashPosition(self.allocator, bucket_col);
            const hashValue = @mod(hash, self.maximumBuckets);
            //print("{s}-hashvalue :{d}\n",.{element,hashValue});
            const posFound = hashmap.get(hashValue) orelse null;

            if (posFound) |position| {
                var requiredList = self.buckets.items[position];
                try requiredList.append(element);
                //std.debug.print("{s} (hash value {d}) dropped in existing bucket {d}\n", .{ element, hashValue, position });
            } else {
                var newList = std.ArrayList(T).init(self.allocator);
                try newList.append(element);
                try self.buckets.append(newList);
                try hashmap.put(hashValue, self.buckets.items.len - 1);
                //std.debug.print("{s} (hash value {d}) dropped in new bucket {d}\n", .{ element, hashValue, self.buckets.items.len - 1 });
            }
        }

        fn getLength(self: *Self) usize {
            return self.buckets.items.len;
        }

        fn findItem(self: *Self, element: []const u8) !?T {
            const hash = try getHashPosition(self.allocator, element);
            const hashValue = @mod(hash, self.maximumBuckets);
            //print("{s}-hashvalue :{d}\n",.{element,hashValue});

            const bucketNo = hashmap.get(hashValue) orelse null;

            if (bucketNo) |bucket| {
                const bucketToScan = self.buckets.items[bucket];
               
                for (bucketToScan.items) |item| {
                    if (std.mem.eql(u8, item.tconst, element)) {
                       return item;
                    }
                }
                
            }

            return null;
        }

        fn deinit(self: *Self) void {
            for (self.buckets.items) |item| {
                item.deinit();
            }

            self.buckets.deinit();
            self.allocator.destroy(self);
            hashmap.deinit();
        }

        pub fn hashSum(input: []const u8) u64 {
            var total: u64 = 0;
            for (input[0..]) |ch| {
                total += @as(u8, ch);
            }
            return total;
        }
    };
}

fn HexHash(comptime Hasher: anytype) type {
    return struct {
        allocator: std.mem.Allocator,
        hex_digest: []u8 = undefined,

        const Self = @This();
        fn init(allocator: std.mem.Allocator) Self {
            return Self{ .allocator = allocator };
        }

        fn hex_hash(self: *Self, input: []const u8) !void {
            const digest = _hasher_digest(input);

            self.hex_digest = try std.fmt.allocPrint(
                self.allocator,
                "{s}",
                .{std.fmt.fmtSliceHexLower(&digest)},
            );
        }
        fn _hasher_digest(input: []const u8) [Hasher.digest_length]u8 {
            var hasher = Hasher.init(.{});
            hasher.update(input);
            var out: [Hasher.digest_length]u8 = undefined;
            hasher.final(out[0..]);
            return out;
        }

        fn deinit(self: *Self) void {
            self.allocator.free(self.hex_digest);
        }
    };
}

