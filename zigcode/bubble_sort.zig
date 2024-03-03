const std = @import("std");

pub fn main() void {
    var arr = [_]u32{ 3, 5, 8, 1, 9 };
    bubbleSort(&arr);
    print(&arr);
}

fn bubbleSort(arr: []u32) void {
    const len = arr.len - 1;
    for (0..len) |i| {
        var swapped: bool = false;
        for (0..len - i) |j| {
            if (arr[j] > arr[j + 1]) {
                const temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }

        if (!swapped) {
            break;
        }
    }
}

fn print(arr: []u32) void {
    for (arr) |e| {
        std.debug.print("{} ", .{e});
    }
}
