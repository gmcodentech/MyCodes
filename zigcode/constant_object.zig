const std = @import("std");
pub fn main() void {
    const node = Value{}; //constant
    node.show();
}

const Value = struct {
    const Self = @This();
    value: i32 = undefined,
    fn show(self: *const Self) void {
        self.value = 35; // error : cannot assign to constant
        std.debug.print("Value class object and value is {d}", .{self.value});
    }
};
