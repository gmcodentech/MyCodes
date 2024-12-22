const std = @import("std");
const fs = std.fs;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const ltoc = try ZDSV(Movie).init(allocator);
    defer ltoc.deinit();

    const objects = try ltoc.get("C:\\Software\\Dotnet\\Data\\cleanhashed.txt", "#", true, 100);

    std.debug.print("Total movies {d}\n", .{objects.items.len});
    var inc: usize = 0;
    for (objects.items) |object| {
        std.debug.print("{s:12}|{d:5}|{d:5}|{s:80}|{s:30}\n", .{ object.tconst, object.start_year, object.run_len, object.primary_title, object.genres });
        inc += 1;
        if (inc == 20) {
            break;
        }
    }

    std.debug.print("completed", .{});
}

const Movie = struct { tconst: []const u8, title_type: []const u8, primary_title: []const u8, original_title: []const u8, is_adult: u1, start_year: u16, end_year: u16, run_len: u16, genres: []const u8 };
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

                if (n != 0 and counter == n) {
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
            const dsv = std.mem.trimLeft(u8,std.mem.trimRight(u8, value, "\r"),"");
            const typeInfo = @typeInfo(data_type);
            switch (typeInfo) {
                .Int => return try std.fmt.parseInt(data_type, dsv, 10),
                .Float => return try std.fmt.parseFloat(data_type, dsv),
                else => return dsv,
            }
        }
    };
}

