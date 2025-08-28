const std = @import("std");

const User = struct {
    id: u32,
    name: []const u8,

    // new field added
    active: ?bool = null, // 👈 default value
    // OR: active: ?bool = null, // optional
};

pub fn main() !void {
    const json_str =
        \\{ "id": 1, "name": "Sayaji" }
    ;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var parsed = try std.json.parseFromSlice(User, allocator, json_str, .{
        .ignore_unknown_fields = true,
    });
    defer parsed.deinit();

    const user = parsed.value;
    std.debug.print("id={d}, name={s}, active={any}\n", .{ user.id, user.name, user.active });
}