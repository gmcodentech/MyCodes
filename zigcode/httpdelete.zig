const std = @import("std");
const print = std.debug.print;
const http = std.http;
pub fn main() !void{
		const allocator = std.heap.page_allocator;
		
		var uri = try std.Uri.parse("http://admin:admin@localhost:5984/catalog/9170c682dd835642f5bb7521a8009e19?rev=1-7f1573202c893ad8964404fd34822dcf");
		uri.user = .{ .raw = "admin"};
		uri.password = .{ .raw = "admin"};
		var client = http.Client{ .allocator = allocator};
		defer client.deinit();
		var buf: [1024]u8 = undefined;

		var req = try client.open(.DELETE, uri, .{ .server_header_buffer = &buf });
		defer req.deinit();
		
		try req.send();		
		try req.finish();
		try req.wait();
		
		var rdr = req.reader();
		const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
		print("{s}",.{body});
}