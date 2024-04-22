const std = @import("std");
const print = std.debug.print;
const http = std.http;
const is_zig_12 = @import("builtin").zig_version.minor == 12;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // var headers = http.Headers{ .allocator = allocator };
    // defer headers.deinit();

    var uri = try std.Uri.parse("http://localhost:5984/productsdb/_all_docs");
    uri.user = .{ .raw = "admin" };
    uri.password = .{ .raw = "1234" };

    const buf = try allocator.alloc(u8, 1024 * 1024 * 4);
    defer allocator.free(buf);

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    var req = try client.open(.GET, uri, .{
        .server_header_buffer = buf,
    });
    defer req.deinit();

    try req.send();
    try req.finish();
    try req.wait();

    try std.testing.expectEqual(req.response.status, .ok);
    var iter = req.response.iterateHeaders();
    while (iter.next()) |header| {
        std.debug.print("Name:{s}, Value:{s}\n", .{ header.name, header.value });
    }

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    defer allocator.free(body);

    print("Body:\n{s}\n", .{body});
}
