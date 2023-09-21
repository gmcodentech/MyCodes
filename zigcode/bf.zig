const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const bf_size: u64 = 1000;
    var bf = try BloomFilter.init(allocator, bf_size);
    defer bf.deinit();

    for (bf.bits) |*b| {
        b.* = @as(u1, 0);
    }

    const stdin = std.io.getStdIn();
    defer stdin.close();

    var txtBuf: [20]u8 = undefined;
    std.debug.print("Enter a text to set :", .{});
    var text1 = (try readLine(stdin.reader(), &txtBuf)).?;

    try bf.setBFBit(&text1);

    std.debug.print("Enter a text to check the presence :", .{});
    var text2 = (try readLine(stdin.reader(), &txtBuf)).?;
    if (bf.checkIfPresent(&text2)) {
        std.debug.print("Present", .{});
    } else {
        std.debug.print("Absent", .{});
    }
}

const BloomFilter = struct {
    bits: []u1,
    allocator: std.mem.Allocator,
    size: u64,

    fn init(allocator: std.mem.Allocator, size: u64) !BloomFilter {
        return .{ .allocator = allocator, .bits = try allocator.alloc(u1, size), .size = size };
    }

    fn setBFBit(bf: BloomFilter, text: *[]const u8) !void {
        const sha384hashValue = try calcHash(std.crypto.hash.sha2.Sha384, text.*);

        var pos = @mod(sha384hashValue, bf.size);
        bf.bits[pos] = 1;
        //std.debug.print("{d}",.{bf.bits[pos]});

        const sha512hashValue = try calcHash(std.crypto.hash.sha2.Sha512, text.*);
        pos = @mod(sha512hashValue, bf.size);
        bf.bits[pos] = 1;
        //std.debug.print("{d}",.{bf.bits[pos]});
    }

    fn checkIfPresent(bf: BloomFilter, text: *[]const u8) bool {
        const sha384hashValue = try calcHash(std.crypto.hash.sha2.Sha384, text.*);

        var pos = @mod(sha384hashValue, bf.size);
        const present1 = bf.bits[pos] == 1;

        const sha512hashValue = try calcHash(std.crypto.hash.sha2.Sha512, text.*);
        pos = @mod(sha512hashValue, bf.size);

        const present2 = bf.bits[pos] == 1;
        return present1 and present2;
    }

    fn deinit(self: *BloomFilter) void {
        self.allocator.free(self.bits);
    }
};

fn readLine(reader: anytype, buffer: []u8) !?[]const u8 {
    var line = (try reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    )) orelse return null;

    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}

fn calcHash(comptime Hasher: anytype, input: []const u8) !u64 {
    var h: [Hasher.digest_length]u8 = undefined;
    Hasher.hash(input, &h, .{});
    return try hashSum(h[0..]);
}

pub fn hashSum(input: []const u8) !u64 {
    var total: u64 = 0;
    for (input[0..]) |ch| {
        total += @as(u8, ch);
    }
    return total;
}
