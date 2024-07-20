const std = @import("std");
const fs = std.fs;
pub fn ZDSV(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        var arena: std.heap.ArenaAllocator = undefined;

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) !*Self {
            arena = std.heap.ArenaAllocator.init(allocator);
            const arenaAllocator = arena.allocator();
            const ltoc = try arenaAllocator.create(Self);
            ltoc.* = Self{ .allocator = arenaAllocator };
            return ltoc;
        }

        pub fn get(self: *Self, input_file: []const u8, sep: []const u8, header: bool, n: usize) !*std.ArrayList(T) {
            var objects = std.ArrayList(T).init(self.allocator);
            //Read lines
            const file = try fs.cwd().openFile(input_file, .{});
            defer file.close();

            var buf_reader = std.io.bufferedReader(file.reader());
            const reader = buf_reader.reader();

            var line = std.ArrayList(u8).init(self.allocator);

            const writer = line.writer();
            var header_line_processed: bool = !header;
            var counter: usize = 0;
            while (reader.streamUntilDelimiter(writer, '\n', null)) : (counter += 1) {
                defer line.clearRetainingCapacity();
                if (!header_line_processed) {
                    header_line_processed = true;
                    continue;
                }
                const str = try self.allocator.dupe(u8, line.items);
                const obj = try getObject(self.allocator, str, sep);

                try objects.append(obj);

                if (counter == n) {
                    break;
                }
            } else |err| switch (err) {
                error.EndOfStream => {},
                else => return err,
            }

            return &objects;
        }

        fn getObject(allocator: std.mem.Allocator, line: []const u8, sep: []const u8) !T {
            const st = @typeInfo(T).Struct;
            const obj = try allocator.create(T);
            const field_count = st.fields.len;

            var tokens = try allocator.alloc([]const u8, field_count);
            var it = std.mem.split(u8, line, sep);
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

            return obj.*;
        }

        pub fn deinit(self: *Self) void {
            self.allocator.destroy(self);
            arena.deinit();
        }

        fn getValue(comptime data_type: type, value: []const u8) !data_type {
            const dsv = std.mem.trimRight(u8, value, "\r");
            const typeInfo = @typeInfo(data_type);
            switch (typeInfo) {
                .Int => return try std.fmt.parseInt(data_type, dsv, 10),
                .Float => return try std.fmt.parseFloat(data_type, dsv),
                else => return dsv,
            }
        }
    };
}
