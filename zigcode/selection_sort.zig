const std = @import("std");

pub fn main() void {
    var arr: [6]u32 = .{ 65, 25, 11, 58, 70, 45 };

    for (0..arr.len) |i| {
        var i_min = i; //for finding minimum

        //find minimum number's position
        for ((i + 1)..arr.len) |j| { //start finding minimum from next position
            if (arr[j] < arr[i_min]) {
                i_min = j;
            }
        }

        //swap current no with min
        if (i_min != i) {
            const temp = arr[i_min];
            arr[i_min] = arr[i];
            arr[i] = temp;
        }
    }

    //display sorted nos
    for (arr) |e| {
        std.debug.print("{d} ", .{e});
    }
}
