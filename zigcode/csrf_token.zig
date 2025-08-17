const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const token = try getCSRFToken(allocator);
    defer allocator.free(token);

    std.debug.print("CSRF Token: {s}\n", .{token});
}

pub fn getCSRFToken(allocator: std.mem.Allocator) ![]u8 {
    var buf: [32]u8 = undefined; // 256-bit random token
    std.crypto.random.bytes(&buf);

    // Allocate buffer for base64 result
    var base64_buf = try allocator.alloc(u8, std.base64.standard.Encoder.calcSize(buf.len));
    const encoded = std.base64.standard.Encoder.encode(base64_buf, &buf);
    return base64_buf[0..encoded.len];
}