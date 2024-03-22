const std = @import("std");
const print = std.debug.print;
const http = std.http;
const is_zig_11 = @import("builtin").zig_version.minor == 11;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    const uri = try std.Uri.parse("http://localhost:5024/add-two-nos"); //"http://localhost:5984/productsdb/f7bdb198abe378b39d0170e72d003c3c");

    //uri.user="admin";
    //uri.password="1234";

    //If any payload has to be sent in the request body
    //const reqData = "{\"name\":\"Bread\",\"price\":334.2,\"units\":190}";

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const first = args[1];
    const second = args[2];

    const AddNo = struct {
        first: i32,
        second: i32,
    };
    const addNo = AddNo{ .first = try std.fmt.parseInt(i32, first, 10), .second = try std.fmt.parseInt(i32, second, 10) };
    const reqData = try std.json.stringifyAlloc(allocator, addNo, .{});
    defer allocator.free(reqData);

    //const reqData = "{\"first\":123,\"second\":334}";
    const buf = try allocator.alloc(u8, 1024 * 1024 * 4);
    defer allocator.free(buf);
    var req = try client.open(.POST, uri, .{
        .server_header_buffer = buf,
    });
    errdefer req.deinit();

    req.transfer_encoding = .chunked;
    req.headers.content_type = .{ .override = "application/json" };

    try req.send(.{});
    try req.writeAll(reqData);

    try req.finish();
    try req.wait();

    defer req.deinit();

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    defer allocator.free(body);

    print("Body:\n{s}\n", .{body});
}
