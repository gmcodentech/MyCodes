const std = @import("std");
const Allocator = std.mem.Allocator;

const Node = struct {
    value: i32,
    next: ?*Node,
};

pub fn main() !void {
    var root = Node{ .value = 32, .next = null };
    const allocator = std.heap.page_allocator;

    const n1 = try add(allocator, &root, 90);
    const n2 = try add(allocator, n1, 84);
    const n3 = try add(allocator, n2, 42);

    print(&root);

    std.debug.print("There are {} nodes\n", .{count(n3)});
    //cleaning
    allocator.destroy(n1);
    allocator.destroy(n2);
    allocator.destroy(n3);
}

fn count(root: *Node) usize {
    var counter: usize = 0;
    var node: ?*Node = root;
    while (node) |n| {
        counter += 1;
        node = n.next;
    }
    return counter;
}

fn print(root: *Node) void {
    var node: ?*Node = root;
    while (node) |n| {
        std.debug.print("{}\n", .{n.value});
        node = n.next;
    }
}

fn add(allocator: Allocator, node: *Node, value: i32) !*Node {
    var new_node = try allocator.create(Node);
    new_node.* = .{
        .value = value,
        .next = null,
    };
    node.next = new_node;
    return new_node;
}
