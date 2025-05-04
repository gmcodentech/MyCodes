const std = @import("std");

pub fn main() !void{
	const address = try std.net.Address.parseIp4("127.0.0.1",3000);
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
	try req.respond("Hello world!\n",std.http.Server.Request.RespondOptions{});
}