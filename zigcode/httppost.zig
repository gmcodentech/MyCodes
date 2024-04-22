const std = @import("std");
const print = std.debug.print;
const http = std.http;
const is_zig_11 = @import("builtin").zig_version.minor == 12;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var uri = try std.Uri.parse("http://localhost:5984/productsdb/0fc1c515b1cabe19f084ee04af00009f");

    uri.user = .{ .raw = "admin" };
    uri.password = .{ .raw = "1234" };

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();
    var buf: [1024]u8 = undefined;
    const payload =
        \\ {
        \\	"name":"burger",
        \\	"price":1545.50,
        \\ 	"units":124
        \\ }
    ;

    var req = try client.open(.PUT, uri, .{ .server_header_buffer = &buf });
    defer req.deinit();

    req.transfer_encoding = .{ .content_length = payload.len };
    try req.send();
    var wtr = req.writer();
    try wtr.writeAll(payload);
    try req.finish();
    try req.wait();

    //try std.testing.expectEqual(req.response.status, .ok);
    //print("Headers:\n{}\n", .{req.response.headers});

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    defer allocator.free(body);

    print("Body:\n{s}\n", .{body});
}
