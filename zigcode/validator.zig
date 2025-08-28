const std = @import("std");

pub const ValidationError = struct {
    field: []const u8,
    message: []const u8,
};

pub const Validator = struct {
    allocator: std.mem.Allocator,

    pub fn validate(self: *Validator, data: std.StringHashMap([]const u8), rules: std.StringHashMap([]const u8)) ![]ValidationError {
        var errors = std.ArrayList(ValidationError).init(self.allocator);

        var it = rules.iterator();
        while (it.next()) |entry| {
            const field = entry.key_ptr.*;
            const rule_str = entry.value_ptr.*;
            const value = data.get(field) orelse "";

            var rule_it = std.mem.tokenizeSequence(u8, rule_str, "|");
            while (rule_it.next()) |rule| {
                var parts = std.mem.tokenizeSequence(u8, rule, ":");
                const rule_name = parts.next() orelse "";
                const rule_param = parts.next() orelse "";

                // Required always checks
                if (std.mem.eql(u8, rule_name, "required")) {
                    if (value.len == 0) {
                        try errors.append(.{ .field = field, .message = "Field is required" });
                    }
                    continue;
                }

                // Skip if blank
                if (value.len == 0) continue;

                if (std.mem.eql(u8, rule_name, "min")) {
                    const min = try std.fmt.parseInt(usize, rule_param, 10);
                    if (value.len < min) try errors.append(.{ .field = field, .message = "Too short" });
                } else if (std.mem.eql(u8, rule_name, "max")) {
                    const max = try std.fmt.parseInt(usize, rule_param, 10);
                    if (value.len > max) try errors.append(.{ .field = field, .message = "Too long" });
                } else if (std.mem.eql(u8, rule_name, "equals")) {
                    if (!std.mem.eql(u8, value, rule_param)) {
                        try errors.append(.{ .field = field, .message = "Does not match expected value" });
                    }
                } else if (std.mem.eql(u8, rule_name, "integer")) {
                    if (std.fmt.parseInt(i64, value, 10)) |_| {} else |_| {
                        try errors.append(.{ .field = field, .message = "Not an integer" });
                    }
                } else if (std.mem.eql(u8, rule_name, "float")) {
                    if (std.fmt.parseFloat(f64, value)) |_| {} else |_| {
                        try errors.append(.{ .field = field, .message = "Not a float" });
                    }
                } else if (std.mem.eql(u8, rule_name, "email")) {
                    if (std.mem.indexOf(u8, value, "@") == null or
                        std.mem.indexOf(u8, value, ".") == null)
                    {
                        try errors.append(.{ .field = field, .message = "Invalid email" });
                    }
                } else if (std.mem.eql(u8, rule_name, "url")) {
                    if (!(std.mem.startsWith(u8, value, "http://") or std.mem.startsWith(u8, value, "https://"))) {
                        try errors.append(.{ .field = field, .message = "Invalid URL" });
                    }
                } else if (std.mem.eql(u8, rule_name, "date")) {
                    if (value.len != 10 or value[4] != '-' or value[7] != '-') {
                        try errors.append(.{ .field = field, .message = "Invalid date format" });
                    }
                } else if (std.mem.eql(u8, rule_name, "regex")) {
					if (!std.mem.containsAtLeast(u8, value, 1, rule_param)) {
						try errors.append(.{ .field = field, .message = "invalid format" });
					}
                }
            }
        }

        return errors.toOwnedSlice();
    }
};



// ---------------------- Example usage ----------------------
test "Validator with regex, email, and numeric rules" {
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = std.testing.allocator;

    var data = std.StringHashMap([]const u8).init(allocator);
	defer data.deinit();
    try data.put("username", "user_123");
    try data.put("email", "invalid-email@gmail.com");
    try data.put("age", "20");
    try data.put("website", "http://example.com");
    try data.put("dob", "2025-08-23");

    var rules = std.StringHashMap([]const u8).init(allocator);
	defer rules.deinit();
    try rules.put("username", "required|regex:^[a-zA-Z0-9_]+$");
    try rules.put("email", "required|email");
    try rules.put("age", "integer");
    try rules.put("website", "url");
    try rules.put("dob", "date");

    var validator = Validator{ .allocator = allocator };
    const errors = try validator.validate(data, rules);

    defer allocator.free(errors);

    for (errors) |err| {
        std.debug.print("Error: {s} -> {s}\n", .{ err.field, err.message });
    }
}

