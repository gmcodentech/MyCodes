const std = @import("std");
   
pub fn main() void {
   	const f:f32 = 2.3;
   	std.debug.print("{any}\n",.{@TypeOf(f)==f32});
   	std.debug.print("{any}",.{f32});
}
