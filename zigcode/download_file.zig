const std = @import("std");
const http = std.http;
const print = std.debug.print;

pub fn main() !void{
	const uri = try std.Uri.parse("http://httpbin.org/image/jpeg");
		
	const file_name = "image.jpeg";	
	
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
	
	var client = http.Client{ .allocator = allocator };
    defer client.deinit();
	
	
	var buf: [8096]u8 = undefined;
	const reqOpt = http.Client.RequestOptions{ .server_header_buffer = &buf };
    var req = try client.open(.GET, uri, reqOpt);
    defer req.deinit();
    try req.send(.{});

    try req.wait();
    if (req.response.status == .ok) {
        print("Response Status:{}\n", .{req.response.status});
        
        var rdr = req.reader();
        const content = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
        defer allocator.free(content);

        const file = try std.fs.cwd().createFile(file_name,.{},);
		defer file.close();

		try file.writeAll(content);
    }
}