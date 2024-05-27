const std = @import("std");
const fs = std.fs;
const print = std.debug.print;



pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile("C:/Software/Dotnet/Data/short.tsv", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 0;
	
	var lines = try allocator.alloc([]const u8,23);
	defer {
		for (lines) |l|{
			allocator.free(l);
		}
		allocator.free(lines);
	}
    while (reader.streamUntilDelimiter(writer, '\n', null)) : (line_no += 1) {
        defer line.clearRetainingCapacity();
		const str = try allocator.dupe(u8,line.items);	
		lines[line_no] = str;
		if(line_no == 22){
			break;
		}
    } else |err| switch (err) {
        error.EndOfStream => {}, // Continue on
        else => return err, // Propagate error
    }

	for (lines) |l|{
		std.debug.print("{s}\n",.{l});
	}
}
