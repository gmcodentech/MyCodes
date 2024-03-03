const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const IntStack = Stack(u32);
    var stack = IntStack.init(allocator);
    defer stack.deinit();

    try stack.push(32);
    try stack.push(200);
    try stack.push(12);
    try stack.push(2);

    std.debug.print("{d}\n", .{stack.pop().?});
    std.debug.print("{d}\n", .{stack.top().?});
    std.debug.print("{d}\n", .{stack.pop().?});

    std.debug.print("{any}\n", .{stack.isEmpty()});
}

fn Stack(comptime T: type) type {
    return struct {
        stack: ArrayList(T),
        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            return Self{ .stack = ArrayList(T).init(allocator) };
        }

        pub fn deinit(self: *Self) void {
            self.stack.deinit();
        }

        pub fn push(self: *Self, value: T) !void {
            try self.stack.append(value);
        }

        pub fn pop(self: *Self) ?T {
            return self.stack.popOrNull();
        }

        pub fn top(self: *Self) ?T {
            if (self.stack.items.len == 0) {
                return null;
            } else {
                return self.stack.items[self.stack.items.len - 1];
            }
        }

        pub fn count(self: *Self) usize {
            return self.stack.items.len;
        }

        pub fn isEmpty(self: *Self) bool {
            return self.count() == 0;
        }
    };
}
