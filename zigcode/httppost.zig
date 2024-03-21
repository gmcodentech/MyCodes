const std = @import("std");
const print = std.debug.print;
const http = std.http;
const is_zig_11 = @import("builtin").zig_version.minor == 12;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var headers = http.Headers{ .allocator = allocator };
    defer headers.deinit();
	
	var uri = try std.Uri.parse("http://httpbin.org/post");//"http://localhost:5024/add-two-nos");
		
	try headers.append("accept", "application/json");
	try headers.append("Content-Type", "application/json");	

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    const reqData = "{\"first\":2,\"second\":4}\n";
	
    var req = if (is_zig_11) blk: {
        var req = try client.request(.POST, uri, headers, .{});
        errdefer req.deinit();

		req.transfer_encoding=.chunked;
		try req.start();
		
		var wrtr = req.writer();
        try wrtr.writeAll(reqData);
		try req.finish();
		
        break :blk req;
    } else blk: {
        var req = try client.open(.POST, uri, headers, .{});
        errdefer req.deinit();
		
		req.transfer_encoding=.chunked;
		
        try req.send(.{});
		
		var wrtr = req.writer();
        try wrtr.writeAll(reqData);
		try req.finish();
		
        break :blk req;
    };
    defer req.deinit();

    try req.wait();

    try std.testing.expectEqual(req.response.status, .ok);
    print("Headers:\n{}\n", .{req.response.headers});

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    defer allocator.free(body);

    print("Body:\n{s}\n", .{body});
}
