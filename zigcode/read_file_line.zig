const std = @import("std");
const fs = std.fs;
pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const alc = gpa.allocator();
 
	var file_buf:[100]u8 = undefined;
	std.debug.print("Enter the filename: ",.{});
	const input_file: []const u8 = try read_file_path(&file_buf); 

	var buf:[20]u8 = undefined;
	std.debug.print("Enter the line count ",.{});
	const n:u8  = try read_line_count(&buf);
	   
	const file = try fs.cwd().openFile(input_file, .{});
    defer file.close();

  // Things are _a lot_ slower if we don't use a BufferedReader
  var buffered = std.io.bufferedReader(file.reader());
  var reader = buffered.reader();

  // lines will get read into this
  var arr = std.ArrayList(u8).init(alc);
  defer arr.deinit();

  var line_count: usize = 0;
  var byte_count: usize = 0;
  while (true) {
    reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
      error.EndOfStream => break,
      else => return err,
    };
    const str = try alc.dupe(u8, arr.items);
    std.debug.print("{s}\n",.{str});
    line_count += 1;
    byte_count += arr.items.len;
    arr.clearRetainingCapacity();
    
    
	alc.free(str);
	 if (n != 0 and line_count == n) {
                    break;
                }
  }
  std.debug.print("{d} lines, {d} bytes", .{line_count, byte_count});
}

fn read_file_path(buf:[]u8) ![]const u8{

	const stdin = std.io.getStdIn();

	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const filepath = std.mem.trimRight(u8, line, "\r");
		return filepath;
	}
	
	return "";
}

fn read_line_count(buf:[]u8) !u8{

	const stdin = std.io.getStdIn();

	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const no = std.mem.trimRight(u8, line, "\r");
		return std.fmt.parseInt(u8,no,10);
	}
	
	return 0;
}