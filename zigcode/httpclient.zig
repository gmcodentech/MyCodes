const std = @import("std");
const print = std.debug.print;
const http = std.http;
const is_zig_12 = @import("builtin").zig_version.minor == 12;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var headers = http.Headers{ .allocator = allocator };
    defer headers.deinit();
	
	var uri = try std.Uri.parse("http://admin:1234@localhost:5984/productsdb/_all_docs");
	uri.user = "admin";
    uri.password = "1234";
	
	//base64 encoding			
	var buffer: [0x100]u8 = undefined;
	const user_pass = try std.fmt.allocPrint(allocator,"{s}:{s}",.{uri.user.?,uri.password.?});
	defer allocator.free(user_pass);
	
	const encoded = std.base64.standard.Encoder.encode(&buffer, user_pass);
	
	const auth_key=try std.fmt.allocPrint(allocator,"Basic {s}",.{encoded});
	defer allocator.free(auth_key);
	
	try headers.append("Authorization", auth_key);

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    
    var req = if (is_zig_12) blk: {
        var req = try client.request(.GET, uri, headers, .{});
        errdefer req.deinit();

        try req.start();
        break :blk req;
    } else blk: {
        var req = try client.open(.GET, uri, headers, .{});
        errdefer req.deinit();

        try req.send(.{});
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
