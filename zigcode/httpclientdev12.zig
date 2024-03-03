const std = @import("std");
const print = std.debug.print;
const http = std.http;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    var uri = try std.Uri.parse("http://localhost:5984/productsdb/_all_docs?include_docs=true");
    uri.user = "admin";
    uri.password = "1234";
    var buf: [8096]u8 = undefined;
    const reqOpt = http.Client.RequestOptions{ .server_header_buffer = &buf };
    var req = try client.open(.GET, uri, reqOpt);
    defer req.deinit();
    try req.send(.{});

    try req.wait();
    if (req.response.status == .ok) {
        print("Response Status:{}\n", .{req.response.status});
        //const header_buffer = req.response.parser.header_bytes_buffer;
        //print("Header:{s}",.{header_buffer});
        var rdr = req.reader();
        const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
        defer allocator.free(body);

        print("Body:\n{s}\n", .{body});
    }
}
