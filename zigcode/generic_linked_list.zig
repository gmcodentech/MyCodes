const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var list = LinkedList(i32).init(allocator);
    defer list.deinit();

    try list.append(23);
    try list.append(47);
    try list.append(-33);
    try list.append(85);
    try list.append(17);

    list.print();
    std.debug.print("\nTotal Items {d}", .{list.count()});
}
//Generic linked list
pub fn LinkedList(comptime T: type) type {
    return struct {
        root: ?*Node(T) = null,
        allocator: Allocator,

        const Self = @This();

        fn init(allocator: Allocator) Self {
            return Self{ .allocator = allocator };
        }

        fn append(self: *Self, value: T) !void {
            const alc = self.allocator;
            var node = try alc.create(Node(T));
            node.* = Node(T){ .value = value };

            if (self.root == null) {
                self.root = node;
                return;
            }

            var head = self.root;
            while (head) |h| {
                if (h.next == null) {
                    h.next = node;
                    return;
                }
                head = h.next;
            }
        }

        fn deinit(self: *Self) void {
            var node: ?*Node(T) = self.root;
            const alc = self.allocator;
            while (node) |n| {
                const addr = n.next;
                alc.destroy(n);
                node = addr;
            }
        }

        fn count(self: *Self) usize {
            var counter: usize = 0;
            var node: ?*Node(T) = self.root;
            while (node) |n| {
                counter += 1;
                node = n.next;
            }

            return counter;
        }

        //print the values
        fn print(self: *Self) void {
            var node: ?*Node(T) = self.root;
            while (node) |n| {
                std.debug.print("{} ", .{n.value});
                node = n.next;
            }
        }
    };
}

fn Node(comptime T: type) type {
    return struct {
        value: T,
        next: ?*Node(T) = null,
    };
}
