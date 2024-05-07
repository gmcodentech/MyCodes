const std = @import("std");

pub fn main() void{
	std.log.debug("A = {d}",.{3});
	std.log.warn("warning",.{});
	std.log.info("info",.{});
}