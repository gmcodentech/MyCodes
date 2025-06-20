const std = @import("std");
const print = std.debug.print;
const ZDSV = @import("zdsv.zig").ZDSV;

pub fn main() !void {
    var dbg = std.heap.DebugAllocator(.{}){};
    defer _ = dbg.deinit();
    const allocator = dbg.allocator();
    const zdsv = try ZDSV(User).init(allocator);
    defer zdsv.deinit();
    const users = try zdsv.get("users.csv", ",", false, 10);
    for (users.items) |*user| {
        print("{d} {s} {d}\n", .{ user.id, user.name, user.age });
    }
}

const User = struct {
    id: u32,
    name: []const u8,
    age: u8,
};
