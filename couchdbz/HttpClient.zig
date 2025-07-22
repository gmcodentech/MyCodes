const std = @import("std");
const http = std.http;

pub const HttpClient = struct{
	input_url: []const u8,
	user:[]const u8,
	password:[]const u8,
	const Self = @This();
	
	pub fn init(input_url:[]const u8,user:[]const u8, pass:[]const u8) HttpClient{
		return HttpClient{.input_url=input_url,.user=user,.password=pass};
	}
	pub fn get(self:*Self,allocator:std.mem.Allocator) ![]u8{
		var uri = try std.Uri.parse(self.input_url);
		uri.user = .{ .raw = self.user };
		uri.password = .{ .raw = self.password };

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

		var rdr = req.reader();
		const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
		return body;
	}
	
	pub fn put(self:*Self,allocator:std.mem.Allocator,payload:[]u8) ![]u8{
		var uri = try std.Uri.parse(self.input_url);
		uri.user = .{ .raw = self.user };
		uri.password = .{ .raw = self.password };
		var client = http.Client{ .allocator = allocator };
		defer client.deinit();
		var buf: [1024]u8 = undefined;

		var req = try client.open(.PUT, uri, .{ .server_header_buffer = &buf });
		defer req.deinit();

		req.transfer_encoding = .{ .content_length = payload.len };
		try req.send();
		var wtr = req.writer();
		try wtr.writeAll(payload);
		try req.finish();
		try req.wait();
		var rdr = req.reader();
		const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
		return body;
	}
	
	pub fn delete(self:*Self,allocator:std.mem.Allocator) ![]u8{	
		var uri = try std.Uri.parse(self.input_url);
		uri.user = .{ .raw = self.user };
		uri.password = .{ .raw = self.password };
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
		return body;
	}
};