const std = @import("std");
const http = std.http;
pub const HttpClient = struct {
    allocator: std.mem.Allocator,
    user: []const u8,
    password: []const u8,
    client: http.Client,
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, user: []const u8, pass: []const u8) HttpClient {
        return HttpClient{ .allocator = allocator, .user = user, .password = pass, .client = http.Client{ .allocator = allocator } };
    }

    pub fn deinit(self: *Self) void {
        self.client.deinit();
    }
    pub fn send(self: *Self, method: http.Method, input_url: []const u8, payload: []u8) ![]u8 {
        if (method == .PUT) {
            return post_req(self, method, input_url, payload);
        }
        return get_req(self, method, input_url);
    }

    fn get_req(self: *Self, method: http.Method, input_url: []const u8) ![]u8 {
        var uri = try std.Uri.parse(input_url);
        uri.user = .{ .raw = self.user };
        uri.password = .{ .raw = self.password };

        const buf = try self.allocator.alloc(u8, 1024 * 1024 * 4);
        defer self.allocator.free(buf);

        var req = try self.client.open(method, uri, .{
            .server_header_buffer = buf,
        });
        defer req.deinit();

        try req.send();
        try req.finish();
        try req.wait();

        var rdr = req.reader();
        const body = try rdr.readAllAlloc(self.allocator, 1024 * 1024 * 4);
        return body;
    }

    fn post_req(self: *Self, method: http.Method, input_url: []const u8, payload: []u8) ![]u8 {
        var uri = try std.Uri.parse(input_url);
        uri.user = .{ .raw = self.user };
        uri.password = .{ .raw = self.password };

        var buf: [1024]u8 = undefined;

        var req = try self.client.open(method, uri, .{ .server_header_buffer = &buf });
        defer req.deinit();

        req.transfer_encoding = .{ .content_length = payload.len };
        try req.send();
        var wtr = req.writer();
        try wtr.writeAll(payload);
        try req.finish();
        try req.wait();
        var rdr = req.reader();
        const body = try rdr.readAllAlloc(self.allocator, 1024 * 1024 * 4);
        return body;
    }
};
