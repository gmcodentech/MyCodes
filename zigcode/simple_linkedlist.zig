const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    //const listInt = LinkedList(u32);
    var list = LinkedList(u32).init(allocator);
    defer list.deinit();
    try list.add(43);
    try list.add(90);
    try list.add(40);
    try list.add(8);
    try list.add(4);
    try list.add(31);
    try list.add(59);
    std.debug.print("{d}\n", .{list.len()});
    const arr = try list.traverse();
    defer allocator.free(arr);
    std.debug.print("{any}\n", .{arr});
    list.remove(4);
    list.remove(59);
    try list.add(950);
    std.debug.print("{d}\n", .{list.len()});
    const found = list.search(950);
    std.debug.print("Found {d} {any}\n", .{ 950, found });
    const arr1 = try list.traverse();
    defer allocator.free(arr1);
    std.debug.print("{any}\n", .{arr1});
}

fn LinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            data: T,
            next: ?*Node = null,
        };

        allocator: std.mem.Allocator,

        head: ?*Node = null,

        count: usize = 0,
        const Self = @This();

        fn init(allocator: std.mem.Allocator) Self {
            return Self{ .allocator = allocator };
        }

        fn deinit(self: *Self) void {
            var it = self.head;
            while (it) |node| {
                const next = node.next;
                self.allocator.destroy(node);
                it = next;
            }
        }

        fn add(self: *Self, value: T) !void {
            const new_node = try self.allocator.create(Node);
            new_node.* = .{ .data = value, .next = self.head };
            self.head = new_node;
            self.count += 1;
            std.debug.print("added {d}\n", .{value});
        }

        fn search(self: *Self, value: T) bool {
            var it = self.head;
            while (it) |node| {
                if (node.data == value) {
                    return true;
                }
                it = node.next;
            }

            return false;
        }

        fn traverse(self: *Self) ![]T {
            var arr = try self.allocator.alloc(T, self.len());
            var i: usize = 0;
            var it = self.head;
            while (it) |node| {
                arr[i] = node.data;
                i += 1;
                it = node.next;
            }

            return arr;
        }

        fn remove(self: *Self, value: T) void {
            std.debug.print("removing... {d}\n", .{value});
            if (self.head.?.data == value) {
                const next = self.head.?.next;
                self.allocator.destroy(self.head.?);
                self.count -= 1;
                self.head = next;
            }

            var it = self.head;
            var prev = self.head;

            while (it) |node| {
                const next = node.next;
                if (node.data == value) {
                    self.allocator.destroy(node);
                    prev.?.next = next;
                    self.count -= 1;
                }
                prev = node;
                it = next;
            }
        }

        fn len(self: *Self) usize {
            // var counter:usize = 0;
            // var it = self.head;
            // while(it) |node| {
            // counter += 1;
            // it = node.next;
            // }

            // return counter;
            return self.count;
        }
    };
}
