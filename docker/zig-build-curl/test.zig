const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	const testPort = std.process.getEnvVarOwned(allocator,"TEST_PORT") catch |err| {
		print("Returned an error now: {any}",.{err});
		return;
	};
	errdefer allocator.free(testPort);
	defer allocator.free(testPort);
	
	print("Server started listening on {s}",.{testPort});
	const address = try std.net.Address.parseIp4("0.0.0.0",try std.fmt.parseInt(u16,testPort,10));
	var server = try address.listen(std.net.Address.ListenOptions{});
	defer server.deinit();
	while(true){
		try handleConnection(try server.accept());
	}

}

fn handleConnection(conn:std.net.Server.Connection)!void{
	defer conn.stream.close();
	var buffer:[1024]u8 = undefined;
	var http_server = std.http.Server.init(conn,&buffer);
	var req = try http_server.receiveHead();
	try req.respond("Coming soon...!\n",std.http.Server.Request.RespondOptions{});
}