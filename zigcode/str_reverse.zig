const std = @import("std");

pub fn main() !void {
    var str: []const u8 = "Is it working?";

    const alc = std.heap.page_allocator;

    const rev = try reverse(str, alc);
    defer alc.free(rev);

    std.debug.print("{s}", .{str});
    std.debug.print("\n{s}", .{rev});
}

fn reverse(str: []const u8, alc: std.mem.Allocator) ![]u8 {
    var rev: []u8 = try alc.alloc(u8, str.len);

    var i: usize = 0;
    var j: usize = str.len;

    while (i < str.len) {
        rev[i] = str[j - 1];
        i += 1;
        j -= 1;
    }

    return rev;
}

test "reverse name" {
    const alc = std.testing.allocator;
    const str: []const u8 = "zig programming";
    const rev = try reverse(str, alc);
    defer alc.free(rev);
    try std.testing.expect(std.mem.eql(u8, rev, "gnimmargorp giz"));
}
