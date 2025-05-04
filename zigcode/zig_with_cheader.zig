const std = @import("std");
const print = std.debug.print;
const c = @cImport({
	@cInclude("foo.h");
});
pub fn main() void{
	print("Hello world!\n",.{});
	const r = c.foo_add(32,44);
	print("Result of addition is {d}",.{r});
}