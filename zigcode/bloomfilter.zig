const std = @import("std");

fn print(comptime fmt:[]const u8, values:anytype)void{
	std.debug.print(fmt++"\n",values);
}

pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator =  gpa.allocator();
	  
	const BF = try BloomFilter.init(allocator,10);
	defer BF.deinit();
	  
	try BF.add("Sweet"); 
	try BF.add("Apple");
	print("Total entries: {d}",.{BF.len()});
	
	print("Found:{any}",.{BF.search("Applde")});
	  
}
  
const BloomFilter = struct {
		allocator:std.mem.Allocator,
		filter:[]u1,
		size:u64,
		index:usize=0,
		  
		const Self = @This();
		fn init(allocator:std.mem.Allocator,size:u64)!*Self{
			const bloom_filter = try allocator.create(Self);
			bloom_filter.* = Self{.allocator = allocator,.size=size, .filter = try allocator.alloc(u1,size)};
			@memset(bloom_filter.filter, 0);
			return bloom_filter;
		}
		 
		fn add(self:*Self,entry:[]const u8) !void{
			const position = @mod(try getHashedIndex(self.allocator,entry), self.size);
			self.filter[position]=1;
			self.index += 1;
		}
		
		fn search(self:*Self,entry:[]const u8) !bool{
			const position = @mod(try getHashedIndex(self.allocator,entry), self.size);
			return self.filter[position] == 1;
		}
		
		fn getHashedIndex(allocator: std.mem.Allocator, element: []const u8) !u64 {
            var hasher = HexHash(std.crypto.hash.sha2.Sha384).init(allocator);
            defer hasher.deinit();
            try hasher.hex_hash(element);
            const hash = hashSum(hasher.hex_digest);
            return hash;
          }
          
          fn hashSum(input: []const u8) u64 {
            var total: u64 = 0;
            for (input[0..]) |ch| {
                total += @as(u8, ch);
            }
            return total;
        	}
		  
		fn deinit(self:*Self)void{
			self.allocator.free(self.filter);
			self.allocator.destroy(self);
		}
		  
		fn len(self:*Self)usize{
			return self.index;
		}
};


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