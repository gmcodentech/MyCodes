const std = @import("std");
const print = std.debug.print;
const http = std.http;
const is_zig_12 = @import("builtin").zig_version.minor == 12;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

	var input_user_buf:[20]u8 = undefined; 
	var input_pass_buf:[20]u8 = undefined; 
	std.debug.print("Username: ",.{});
    const user_name: []const u8 = read_input(&input_user_buf) catch "";
	std.debug.print("Password: ",.{});
	const password: []const u8 = read_input(&input_pass_buf) catch "";
	var input_url_buf:[100]u8 = undefined; 
	std.debug.print("Url: ",.{});
	const input_url: []const u8 = read_input(&input_url_buf) catch "";
	std.debug.print("wait...\n",.{});
	
    var uri = try std.Uri.parse(input_url);
    uri.user = .{ .raw = user_name };
    uri.password = .{ .raw = password };

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

    // try std.testing.expectEqual(req.response.status, .ok);
    // var iter = req.response.iterateHeaders();
    // while (iter.next()) |header| {
        // std.debug.print("Name:{s}, Value:{s}\n", .{ header.name, header.value });
    // }

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    defer allocator.free(body);

    print("Result:\n{s}\n", .{body});
}
fn read_input(buf:[]u8) ![]const u8{
	
	const stdin = std.io.getStdIn();
	//defer stdin.close();
	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const trimmed_line = std.mem.trimRight(u8, line, "\r");
		return trimmed_line;
	}
	
	return "";
}