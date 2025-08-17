const std = @import("std");

pub fn parseEnvFile(allocator: std.mem.Allocator, content: []const u8) !std.StringHashMap([]const u8) {
    var map = std.StringHashMap([]const u8).init(allocator);

    var lines = std.mem.splitAny(u8, content, "\n");
    while (lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, "\r\t");
        if (trimmed.len == 0 or trimmed[0] == '#') continue; // skip empty & comments

        var parts = std.mem.splitSequence(u8, trimmed, "=");
        const key = std.mem.trim(u8, parts.next().?, "\t");
        const value = parts.next() orelse "";

        try map.put(try allocator.dupe(u8, key), try allocator.dupe(u8, value));
    }

    return map;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const env_content =
        \\# Example .env
        \\DB_HOST=localhost
        \\DB_USER=root
        \\DB_PASS=secret
    ;

    var env_map = try parseEnvFile(allocator, env_content);
    defer env_map.deinit();

    var it = env_map.iterator();
    while (it.next()) |entry| {
        std.debug.print("{s} = {s}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}