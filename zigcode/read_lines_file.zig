const std = @import("std");
const fs = std.fs;
const print = std.debug.print;



pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile("C:/Software/Dotnet/Data/imdb.tsv", .{});
    defer file.close();

    // Wrap the file reader in a buffered reader.
    // Since it's usually faster to read a bunch of bytes at once.
    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 1;
	
	var movies = std.ArrayList(*Movie).init(allocator);
	defer movies.deinit();
	
    while (reader.streamUntilDelimiter(writer, '\n', null)) : (line_no += 1) {
        // Clear the line so we can reuse it.
        defer line.clearRetainingCapacity();
		const movie = try getMovie(allocator,line.items);
		defer allocator.destroy(movie);
		try movies.append(movie);
        //print("{d}--{s}\n", .{ line_no, movie.tconst });
		if(line_no == 3){
			break;
		}
    } else |err| switch (err) {
        error.EndOfStream => {}, // Continue on
        else => return err, // Propagate error
    }
	
	for (movies.items) |movie|{
		std.debug.print("{s}\n",.{movie.tconst});
	}
	
	// for (movies.items) |*movie|{
		// allocator.destroy(movie.*);
	// }
}

fn getMovie(allocator:std.mem.Allocator,line:[]const u8) !*Movie{
	var it = std.mem.split(u8, line, "\t");
	const movie = try allocator.create(Movie);
	movie.* = Movie{
		.tconst = if(it.next()) |x| x else "",
		.title_type = if(it.next()) |x| x else "",
		.primary_title = if(it.next()) |x| x else "",
		.original_title = if(it.next()) |x| x else "",
		.isadult = if(it.next()) |x| try std.fmt.parseInt(i32,x,10) else 0,
		.year = if(it.next()) |x| try std.fmt.parseInt(i32,x,10) else 0,
		.length = if(it.next()) |x| try std.fmt.parseInt(i32,x,10) else 0,
		.genres = if(it.next()) |x| x else "",
	};
    return movie;
}

const Movie = struct {
    tconst: []const u8,
    title_type: []const u8,
    primary_title: []const u8,
	original_title: []const u8,
    isadult: i32,
    year: ?i32,
    length: ?i32,
	genres: []const u8,
};
