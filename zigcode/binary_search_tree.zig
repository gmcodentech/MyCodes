const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const gp_allocator = gpa.allocator();

    var arena = std.heap.ArenaAllocator.init(gp_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var bst = BinarySearchTree(u32).init(allocator);
    try bst.insert(15);
    try bst.insert(90);
    try bst.insert(40);
    try bst.insert(95);
    try bst.insert(55);
    try bst.insert(25);
    try bst.insert(100);
    std.debug.print("{d}\n", .{bst.len()});
    std.debug.print("Found: {any}\n", .{bst.search(25)});
}

fn BinarySearchTree(comptime T: type) type {
    return struct {
        const Node = struct {
            data: T,
            left: ?*Node = null,
            right: ?*Node = null,
        };
        allocator: std.mem.Allocator,
        root: ?*Node = null,
        count: usize = 0,

        const Self = @This();

        fn init(allocator: std.mem.Allocator) Self {
            return .{ .allocator = allocator };
        }

        fn _new(allocator: std.mem.Allocator, value: T) !*Node {
            const node = try allocator.create(Node);
            node.* = Node{ .data = value };
            return node;
        }

        fn len(self: *Self) usize {
            return self.count;
        }

        fn search(self: *Self, value: T) bool {
            var it = self.root;
            while (it) |node| {
                if (node.data == value) {
                    return true;
                } else {
                    if (node.data > value) {
                        it = node.left;
                    } else {
                        it = node.right;
                    }
                }
            }
            return false;
        }

        fn insert(self: *Self, value: T) !void {
            const new_node = try _new(self.allocator, value);
            self.count += 1;
            if (self.root == null) {
                self.root = new_node;
                std.debug.print("added {d} at root\n", .{value});
                return;
            }

            var it = self.root;
            var prev: ?*Node = null;
            while (it) |node| {
                if (node.data > value) {
                    prev = node;
                    it = node.left;
                } else if (node.data < value) {
                    prev = node;
                    it = node.right;
                }
            }

            if (prev.?.data > value) {
                prev.?.left = new_node;
                std.debug.print("added {d} on left of {d}\n", .{ value, prev.?.data });
            } else {
                prev.?.right = new_node;
                std.debug.print("added {d} on right of {d}\n", .{ value, prev.?.data });
            }
        }
    };
}
