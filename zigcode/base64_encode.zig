//base64 encoding
const std = @import("std");

pub fn main() !void{	

	const allocator = std.heap.page_allocator;
	
	var buffer: [0x100]u8 = undefined;
	const user_pass = try std.fmt.allocPrint(allocator,"{s}:{s}",.{"admin","1234"});
	defer allocator.free(user_pass);
	
	const encoded = std.base64.standard.Encoder.encode(&buffer, user_pass);
	
	const auth_key=try std.fmt.allocPrint(allocator,"Basic {s}",.{encoded});
	defer allocator.free(auth_key);
	
	std.debug.print("{s}",.{auth_key});
}