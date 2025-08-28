const std = @import("std");

pub const MiniRegex = struct {
    pattern: []const u8,

    pub fn init(pattern: []const u8) MiniRegex {
        return MiniRegex{ .pattern = pattern };
    }

    pub fn match(self: *const MiniRegex, input: []const u8) bool {
        return self.matchHere(self.pattern, input);
    }

    fn matchHere(self: *const MiniRegex, pat: []const u8, text: []const u8) bool {
        if (pat.len == 0) return true;

        switch (pat[0]) {
            // End anchor
            '$' => return text.len == 0,

            // Quantifiers: X* X+ X?
            else => {
                if (pat.len > 1 and (pat[1] == '*' or pat[1] == '+' or pat[1] == '?')) {
                    return self.matchQuantifier(pat, text);
                }

                if (text.len > 0 and self.charMatch(pat, text[0])) {
                    return self.matchHere(pat[1..], text[1..]);
                }
                return false;
            },
        }
    }

    fn matchQuantifier(self: *const MiniRegex, pat: []const u8, text: []const u8) bool {
        const quant = pat[1];
        const rest = pat[2..];

        switch (quant) {
            '*' => {
                var i: usize = 0;
                while (true) {
                    if (self.matchHere(rest, text[i..])) return true;
                    if (i >= text.len or !self.charMatch(pat, text[i])) break;
                    i += 1;
                }
                return false;
            },
            '+' => {
                var i: usize = 0;
                if (text.len == 0 or !self.charMatch(pat, text[0])) return false;
                i = 1;
                while (true) {
                    if (self.matchHere(rest, text[i..])) return true;
                    if (i >= text.len or !self.charMatch(pat, text[i])) break;
                    i += 1;
                }
                return false;
            },
            '?' => {
                if (self.matchHere(rest, text)) return true;
                if (text.len > 0 and self.charMatch(pat, text[0])) {
                    return self.matchHere(rest, text[1..]);
                }
                return false;
            },
            else => return false,
        }
    }

    fn charMatch(self: *const MiniRegex, pat: []const u8, c: u8) bool {
	    _=self;
        if (pat[0] == '.') return true;

        if (pat[0] == '[') {
            var i: usize = 1;
            while (i < pat.len and pat[i] != ']') : (i += 1) {
                if (i + 2 < pat.len and pat[i+1] == '-') {
                    const start = pat[i];
                    const end = pat[i+2];
                    if (c >= start and c <= end) return true;
                    i += 2;
                } else if (c == pat[i]) {
                    return true;
                }
            }
            return false;
        }

        return pat[0] == c;
    }
};

pub fn main() !void {
    var stdout = std.io.getStdOut().writer();

    // const emailPattern = MiniRegex.init("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$");
    // const urlPattern   = MiniRegex.init("^(http|https)://[a-z0-9.-]+\\.[a-z]{2,}.*$");
    const intPattern   = MiniRegex.init("^[0-9]+$");
    //const floatPattern = MiniRegex.init("^[0-9]+(\\.[0-9]+)?$");

    //try stdout.print("Email valid: {}\n", .{emailPattern.match("foo@bar.com")});
    //try stdout.print("URL valid: {}\n", .{urlPattern.match("https://ziglang.org")});
    try stdout.print("Integer valid: {}\n", .{intPattern.match("1")});
    //try stdout.print("Float valid: {}\n", .{floatPattern.match("123.45")});
}
