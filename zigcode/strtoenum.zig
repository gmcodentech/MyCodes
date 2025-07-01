const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
	var buf:[20]u8 = undefined;
	const str = try std.fmt.bufPrint(&buf,"{s}",.{"EHorse"});
	print("{any}",.{std.meta.stringToEnum(AnimalType,str)});
}

const AnimalType = enum{
	EDog,
	ECat,
	EHorse
};