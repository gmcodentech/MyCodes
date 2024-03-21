const std = @import("std");
const print = std.debug.print;
const http = std.http;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var headers = http.Headers{ .allocator = allocator };
    defer headers.deinit();

    var uri = try std.Uri.parse("http://localhost:5984/productsdb/0fc1c515b1cabe19f084ee04af00009f"); //"http://localhost:5024/add-two-nos");

    // uri.user = "admin";
    // uri.password = "1234";

    // //base64 encoding
    // var buffer: [0x100]u8 = undefined;
    // const user_pass = try std.fmt.allocPrint(allocator,"{s}:{s}",.{uri.user.?,uri.password.?});
    // defer allocator.free(user_pass);

    // const encoded = std.base64.standard.Encoder.encode(&buffer, user_pass);

    // const auth_key=try std.fmt.allocPrint(allocator,"Basic {s}",.{encoded});
    // defer allocator.free(auth_key);

    try headers.append("Authorization", "Basic YWRtaW46MTIzNA==");
    try headers.append("accept", "application/json");
    try headers.append("Content-Type", "application/json");

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    const reqData = "{\"name\":\"burger\",\"price\":42.2,\"units\":850}";

    var req = try client.request(.PUT, uri, headers, .{});
    errdefer req.deinit();
    defer req.deinit();

    req.transfer_encoding = .chunked;

    try req.start();

    var wrtr = req.writer();
    try wrtr.writeAll(reqData);

    try req.finish();
    try req.wait();

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    defer allocator.free(body);

    print("Body:\n{s}\n", .{body});
}
