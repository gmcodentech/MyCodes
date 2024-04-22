const std = @import("std");
const print = std.debug.print;

const http = std.http;

pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	const server_addr="127.0.0.1";
	const server_port=8888;
	const max_header_size = 8192;
	
	const address = try std.net.Address.parseIp(server_addr,server_port);
	
	var server = std.http.Server.init(allocator, .{ .reuse_address = true });
	defer server.deinit();
	
	try server.listen(address);
	
	var connCounter:usize = 0;
	var connections:[10] std.Thread = undefined;
	while(connCounter <= 10){
	const server_thread = try std.Thread.spawn(.{}, (struct {
        fn apply(s: *std.http.Server) !void {
				var res = try s.accept(.{
							.allocator = s.allocator,
							.header_strategy = .{ .dynamic = max_header_size },
						});
				defer res.deinit();
				defer _ = res.reset();
				try res.wait();
				
				const server_body: []const u8 = "Hello from server!\n";
				var buf: [128]u8 = undefined;
				_ = try res.readAll(&buf);
				
				const req_body = try res.reader().readAllAlloc(s.allocator,max_header_size);
				defer s.allocator.free(req_body);
				
				res.transfer_encoding = .{ .content_length = server_body.len };
				try res.headers.append("content-type", "text/plain");
				try res.headers.append("connection", "keep-alive");
				try res.do();

				try res.writeAll(server_body);
				try res.finish();
		}
    }).apply, .{&server});
	
	connections[connCounter]=server_thread;
	connCounter += connCounter;
	}
	
	for (connections) |thread|{
		thread.join();
	}
	
	std.debug.print("completed...",.{});
}