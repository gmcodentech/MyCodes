const std = @import("std");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var json_map = std.StringHashMap([]const u8).init(allocator);
    defer {
        json_map.deinit();
    }
    const p1 = try getJson(Product, allocator, "Milk,44.5,300");
    defer allocator.free(p1);
    try json_map.put("1", p1);
    const p2 = try getJson(Product, allocator, "Sugar,53.3,90");
    try json_map.put("2", p2);
    defer allocator.free(p2);
    std.debug.print("{s}\n", .{json_map.get("2").?});
    std.debug.print("{s}\n", .{json_map.get("1").?});
}

fn getJson(comptime T: type, allocator: std.mem.Allocator, line: []const u8) ![]const u8 {
    const st = @typeInfo(T).Struct;
    const obj = try allocator.create(T);
    defer allocator.destroy(obj);

    const field_count = st.fields.len;

    var tokens = try allocator.alloc([]const u8, field_count);
    defer allocator.free(tokens);

    var it = std.mem.split(u8, line, ",");
    var i: usize = 0;
    while (it.next()) |p| {
        tokens[i] = p;
        i += 1;
    }
    i = 0;
    inline for (st.fields) |field| {
        @field(obj, field.name) = try getValue(field.type, tokens[i]);
        i += 1;
    }

    const json_str = try std.json.stringifyAlloc(allocator, obj, .{ .whitespace = .indent_4 });
    return json_str;
}

fn getValue(comptime data_type: type, value: []const u8) !data_type {
    if (data_type == u32) {
        return try std.fmt.parseInt(data_type, value, 10);
    } else if (data_type == f32) {
        return try std.fmt.parseFloat(data_type, value);
    }
    return value;
}

const Product = struct {
    name: []const u8,
    price: f32,
    units: u32,
};
