const std = @import("std");
 
fn get_hasher_digest(comptime Hasher: anytype, input: []const u8) [Hasher.digest_length]u8 {
    var hasher = Hasher.init(.{});
    hasher.update(input);
    return hasher.finalResult();
}
 
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();
 
    const text: []const u8 = "gmcodentech";
    const digest = get_hasher_digest(std.crypto.hash.sha2.Sha256, text);
 
    const hex_digest = try std.fmt.allocPrint(
        allocator,
        "{s}",
        .{std.fmt.fmtSliceHexLower(&digest)},
    );
    defer allocator.free(hex_digest);
 
    std.debug.print("{s}", .{hex_digest});
}