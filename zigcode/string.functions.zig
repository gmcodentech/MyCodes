const std = @import("std");
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	const big = "This is what we want to test";
	 
	//length
	const l = big.len;
	std.debug.print("The length is {d}\n",.{l});
	 
	//equal
	const is_equal = std.mem.eql(u8,"abc","abc");
	std.debug.print("The strings are equal {}\n",.{is_equal});
	 
	//contains
	const contains = std.mem.indexOf(u8,big,"test").?;
	std.debug.print("big contains test {}\n",.{contains});
	 
	//substring
	var output:[29]u8 = undefined;
	const no_of_replacements = std.mem.replace(u8,big,"want","need",output[0..]);
	_ = no_of_replacements;
	std.debug.print("After replace - {s}\n",.{output[0..]});
	
	//concat
	const str = try std.mem.concat(allocator, u8, &[_][]const u8{ "abc", "def", "ghi" });
     defer allocator.free(str);
     std.debug.print("Concatenated- {s}\n",.{str});

	//join
	const str1 = try std.mem.join(allocator, ",", &[_][]const u8{ "a", "b", "c" });
     defer allocator.free(str1);
	std.debug.print("Joined- {s}\n",.{str1});
	
	//startswith
	const is_starting_with = std.mem.startsWith(u8,big,"This");
	std.debug.print("Starts With - {}\n",.{is_starting_with});
	
	//endswith
	const is_ending_with = std.mem.endsWith(u8,big,"test");
	std.debug.print("Ends With - {}\n",.{is_ending_with});
	
	//split
	var it = std.mem.split(u8,big, "what");
	while(it.next()) |part|{
		std.debug.print("{s} ",.{part});
	}
	
	
	//trim
	const str_test = "  something needs to be trimmed\n";
	const trimmed = std.mem.trimLeft(u8,std.mem.trimRight(u8,str_test,"\n")," ");
	std.debug.print("{s} and length is {}",.{trimmed,trimmed.len == "something needs to be trimmed".len});
}