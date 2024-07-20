const std = @import("std");
pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const obj = try getObject(Product, allocator, "Milk,44.5,300");
    defer allocator.destroy(obj);
    std.debug.print("{s} {d} {d}\n", .{ obj.name, obj.price, obj.units });

    const obj2 = try getObject(Point, allocator, "2,3");
    defer allocator.destroy(obj2);
    std.debug.print("{d} {d}\n", .{ obj2.x, obj2.y });
	
	const obj3 = try getObject(House,allocator,"Kalakunj,1,43.5");
	defer allocator.destroy(obj3);
	std.debug.print("{s}  {}  {d}",.{obj3.name,obj3.is_occupied,obj3.price});

}

const House = struct{
	name:[]const u8,
	is_occupied:u1,
	price:f64,
};

const Point = struct { x: i32, y: i32 };

const Product = struct {
    name: []const u8,
    price: f32,
    units: u32,
};

fn getObject(comptime T: type, allocator: std.mem.Allocator, line: []const u8) !*T {
    const st = @typeInfo(T).Struct;
    const obj = try allocator.create(T);

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

    return obj;
}

fn getValue(comptime data_type: type, value: []const u8) !data_type {
    const typeInfo = @typeInfo(data_type);
    switch (typeInfo) {
        .Int => return try std.fmt.parseInt(data_type, value, 10),
        .Float => return try std.fmt.parseFloat(data_type, value),
        else => return value,
    }
}