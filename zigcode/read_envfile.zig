const std = @import("std");

const KeyValue = struct {
    key: []const u8,
    value: []const u8,
};

pub fn parseEnvFile(allocator: std.mem.Allocator, envfile:[]const u8) !std.ArrayList(KeyValue) {
    
	var file = try std.fs.cwd().openFile(envfile, .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const content = try file.readToEndAlloc(allocator, file_size);
    defer allocator.free(content);
	
	var list = std.ArrayList(KeyValue).init(allocator);

    var lines = std.mem.splitAny(u8, content, "\n");
    while (lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \r\t");
        if (trimmed.len == 0 or trimmed[0] == '#') continue; // skip empty & comments

        var parts = std.mem.splitSequence(u8, trimmed, "=");
        const key = std.mem.trim(u8, parts.next().?, " \t");
        const value = parts.next() orelse "";

        try list.append(.{
            .key = try allocator.dupe(u8, key),
            .value = try allocator.dupe(u8, value),
        });
    }

    return list;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // open .env file from current working directory
    

    var env_list = try parseEnvFile(allocator, "config.env");
    defer {
        // free each key/value string
        for (env_list.items) |kv| {
            allocator.free(kv.key);
            allocator.free(kv.value);
        }
        env_list.deinit();
    }

    for (env_list.items) |kv| {
        std.debug.print("{s} = {s}\n", .{ kv.key, kv.value });
    }
}
