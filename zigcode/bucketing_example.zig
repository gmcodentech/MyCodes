const std = @import("std");

fn print(comptime str: []const u8, data: anytype) void {
    std.debug.print(str, data);
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

        fn getHashPosition(allocator: std.mem.Allocator, element: T) !u64 {
            var hasher = HexHash(std.crypto.hash.sha2.Sha384).init(allocator);
            defer hasher.deinit();
            try hasher.hex_hash(element);
            const hash = hashSum(hasher.hex_digest);
            return hash;
        }

        fn addItem(self: *Self, element: T) !void {
            const hash = try getHashPosition(self.allocator, element);
            const hashValue = @mod(hash, self.maximumBuckets);
            //print("{s}-hashvalue :{d}\n",.{element,hashValue});
            const posFound = hashmap.get(hashValue) orelse null;

            if (posFound) |position| {
                var requiredList = self.buckets.items[position];
                try requiredList.append(element);
                print("{s} (hash value {d}) dropped in existing bucket {d}\n", .{ element, hashValue, position });
            } else {
                var newList = std.ArrayList(T).init(self.allocator);
                try newList.append(element);
                try self.buckets.append(newList);
                try hashmap.put(hashValue, self.buckets.items.len - 1);
                print("{s} (hash value {d}) dropped in new bucket {d}\n", .{ element, hashValue, self.buckets.items.len - 1 });
            }
        }

        fn getLength(self: *Self) usize {
            return self.buckets.items.len;
        }

        fn findItem(self: *Self, element: T) !?usize {
            const hash = try getHashPosition(self.allocator, element);
            const hashValue = @mod(hash, self.maximumBuckets);
            //print("{s}-hashvalue :{d}\n",.{element,hashValue});

            const bucketNo = hashmap.get(hashValue) orelse null;

            if (bucketNo) |bucket| {
                const bucketToScan = self.buckets.items[bucket];
                var found: bool = false;
                for (bucketToScan.items) |item| {
                    if (std.mem.eql(u8, item, element)) {
                        found = true;
                        break;
                    }
                }
                if (found) {
                    return bucket;
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

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var factory = try bucketFactory([]const u8).init(allocator, 15);
    defer factory.deinit();

    const fruits = [_][]const u8{ "Mango", "Banana", "Orange", "Mango", "Banana", "Jackfruit", "Apple" };
    for (fruits) |fruit| {
        try factory.addItem(fruit);
    }

    print("Total buckets : {d}\n", .{factory.getLength()});

    const fruitToSearch = "Apple";
    const bucket = try factory.findItem(fruitToSearch);
    if (bucket) |bucketNo| {
        print("Found {s} in bucket no. {d}\n", .{ fruitToSearch, bucketNo });
    } else {
        print("{s} not found in any bucket\n", .{fruitToSearch});
    }

    if (try factory.findItem("Berry")) |bucketNo| {
        print("Berry found in {d}\n", .{bucketNo});
    } else {
        print("Berry not found!", .{});
    }
}
