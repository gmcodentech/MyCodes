pub const packages = struct {
    pub const @"122050a5ca490252dd49aeb2e2163666781da4a7d60ebbd7c74a8650041e2183efaa" = struct {
        pub const build_root = "C:\\Users\\Gautam\\AppData\\Local\\zig\\p\\122050a5ca490252dd49aeb2e2163666781da4a7d60ebbd7c74a8650041e2183efaa";
        pub const build_zig = @import("122050a5ca490252dd49aeb2e2163666781da4a7d60ebbd7c74a8650041e2183efaa");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"12207f9d37f48f14e8891846a00412c659a763acf44bf3f4c559610fa5632597537c" = struct {
        pub const build_root = "C:\\Users\\Gautam\\AppData\\Local\\zig\\p\\12207f9d37f48f14e8891846a00412c659a763acf44bf3f4c559610fa5632597537c";
        pub const build_zig = @import("12207f9d37f48f14e8891846a00412c659a763acf44bf3f4c559610fa5632597537c");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "buffer", "122050a5ca490252dd49aeb2e2163666781da4a7d60ebbd7c74a8650041e2183efaa" },
            .{ "metrics", "1220b8787523d802b8573bf06b12e1da606105c35535aecd7862f616e1863f8d8692" },
        };
    };
    pub const @"1220b8787523d802b8573bf06b12e1da606105c35535aecd7862f616e1863f8d8692" = struct {
        pub const build_root = "C:\\Users\\Gautam\\AppData\\Local\\zig\\p\\1220b8787523d802b8573bf06b12e1da606105c35535aecd7862f616e1863f8d8692";
        pub const build_zig = @import("1220b8787523d802b8573bf06b12e1da606105c35535aecd7862f616e1863f8d8692");
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "pg", "12207f9d37f48f14e8891846a00412c659a763acf44bf3f4c559610fa5632597537c" },
};
