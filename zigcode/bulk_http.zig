const std = @import("std");
const http = std.http;
const print = std.debug.print;
pub fn main() !void{

	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	//print("processing...\n",.{});
	var input_count_buf:[20]u8 = undefined; 
	std.debug.print("Enter count: ",.{});
    const count: u32 = read_count(&input_count_buf) catch 0;
	
	//const count = 100;
	var threads = try allocator.alloc(std.Thread,count);
	defer allocator.free(threads);

	var timer = try std.time.Timer.start();
   
    

    for (0..count) |i| {		
        threads[i] = try std.Thread.spawn(.{}, makeHttpCall, .{allocator});
    }
	
	

    for (0..count) |i| {
        threads[i].join();
    }

    std.debug.print("\ndone", .{});

	const time_0 = timer.read();
	print(" - {d} seconds.",.{time_0/1_000_000_000});
	
	//try makeHttpCall(allocator,url);
	//std.debug.print("{d}",.{d});
}

fn read_count(buf:[]u8) !u32 {
	
	const stdin = std.io.getStdIn();

	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const trimmed_line = std.mem.trimRight(u8, line, "\r");
		return try std.fmt.parseInt(u32,trimmed_line,10);
	}
	
	return 0;
}

fn getRandomInt() !u64{
	 var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

	return rand.intRangeAtMost(u64, 0, 1000);
}

fn makeHttpCall(allocator:std.mem.Allocator) !void{

	const d = try getRandomInt();
	const input_url = try std.fmt.allocPrint(allocator, "http://localhost:8080/api/total/{d}", .{d});
	//print("{s}",.{url});
	defer allocator.free(input_url);
	
	const uri = try std.Uri.parse(input_url);
    

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
    defer allocator.free(body);

	
    //print("Total:{s}\n", .{body});

}