const std = @import("std");
const httpz = @import("httpz");
const pg = @import("pg");
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server().init(allocator, .{ .port = 5882, .cors = .{
        .origin = "http://127.0.0.1",
        .headers = "Origin, X-Requested-With, Content-Type, Accept, Authorization",
    } });
    // set a global dispatch for any routes defined from this point on
    server.dispatcher(mainDispatcher);

    // overwrite the default notFound handler
    server.notFound(notFound);

    // overwrite the default error handler
    server.errorHandler(errorHandler);

    var router = server.router();

    // use get/post/put/head/patch/options/delete
    // you can also use "all" to attach to all methods
    router.getC("/api/user/:id", getUser, .{ .dispatcher = loggedIn });
    router.get("/api/total/:no", getTotal);
    router.deleteC("/v1/session", logout, .{ .dispatcher = loggedIn });

    router.postC("/api/book/save", saveBook, .{ .dispatcher = loggedIn });
    router.get("/api/books", getBooks);

    router.get("/api/intro", getIntro);

    var admin_routes = router.group("/admin", .{ .dispatcher = loggedIn });
    admin_routes.get("/nos/:count", getNos);

    router.get("/api/movies", movieList);
    router.get("/api/movies/:name", searchMovie);

    std.debug.print("started...", .{});
    // start the server in the current thread, blocking.
    try server.listen();
}

fn movieList(req: *httpz.Request, res: *httpz.Response) !void {
    const query = "select tconst,titletype,primarytitle,isadult,startyear,runtimeminutes from movietitles limit 10";
    const values = .{};
    try getMovies(req, res, query, values);
}

fn searchMovie(req: *httpz.Request, res: *httpz.Response) !void {
    const name = req.param("name").?;
    const query =
        \\ select tconst,titletype,primarytitle,isadult,startyear,runtimeminutes 
        \\ from movietitles 
        \\ where titletype='movie' and primarytitle like $1
    ;
    const values = try std.fmt.allocPrint(res.arena, "%{s}%", .{name});
    defer res.arena.free(values);
    try getMovies(req, res, query, .{values});
}

fn getMovies(req: *httpz.Request, res: *httpz.Response, sql: []const u8, values: anytype) !void {
    _ = req;
    var pool = try pg.Pool.init(res.arena, .{ .size = 5, .connect = .{
        .port = 5432,
        .host = "127.0.0.1",
    }, .auth = .{
        .username = "postgres",
        .database = "ProductsDB",
        .password = "1234",
        .timeout = 10_000,
    } });
    defer pool.deinit();

    //var list = try res.arena.alloc(Movie,10);
    //defer res.arena.free(list);

    var list = std.ArrayList(Movie).init(res.arena);
    defer list.deinit();
    // try array.append(1);

    var result = try pool.query(sql, values);
    defer result.deinit();
    //std.debug.print("\nID - Type - Title - Is Adult - Year - Length\n",.{});

    while (try result.next()) |row| {
        const tconst = row.get([]u8, 0);
        const titletype = row.get([]u8, 1);
        const primarytitle = row.get([]u8, 2);
        const isadult = row.get(i32, 3);
        const startyear = row.get(?i32, 4);
        const runtimemins = row.get(?i32, 5);
        try list.append(Movie{ .tconst = tconst, .title_type = titletype, .primary_title = primarytitle, .isadult = isadult, .year = startyear, .length = runtimemins });
    }

    try res.json(list.items, .{});
}

const Movie = struct {
    tconst: []const u8,
    title_type: []const u8,
    primary_title: []const u8,
    isadult: i32,
    year: ?i32,
    length: ?i32,
};

fn getIntro(req: *httpz.Request, res: *httpz.Response) !void {
    _ = req;
    res.body = "Hello this is HTML";
}

fn getNos(req: *httpz.Request, res: *httpz.Response) !void {
    var nos = [_]u32{ 0, 234, 3, 56, 32, 90 };
    const count = req.param("count").?;
    const n = try std.fmt.parseInt(u32, count, 10);
    nos[0] = n;
    try res.json(nos, .{});
}

fn getBooks(req: *httpz.Request, res: *httpz.Response) !void {
    var list = try res.arena.alloc(Book, 2);
    defer res.arena.free(list);
    _ = req;
    list[0] = Book{ .title = "PHP", .pages = 100 };
    list[1] = Book{ .title = ".NET", .pages = 340 };

    try res.json(list, .{});
}

const Book = struct {
    title: []const u8,
    pages: u32,
};

fn mainDispatcher(action: httpz.Action(void), req: *httpz.Request, res: *httpz.Response) !void {
    res.header("cors", "isslow");
    return action(req, res);
}

fn loggedIn(action: httpz.Action(void), req: *httpz.Request, res: *httpz.Response) !void {
    if (req.header("authorization")) |_auth| {
        _ = _auth;
        //std.debug.print("Auth key: {s}",.{_auth});
        // TODO: make sure "auth" is valid!
        return mainDispatcher(action, req, res);
    }
    res.status = 401;
    res.body = "Not authorized";
}

fn logout(req: *httpz.Request, res: *httpz.Response) !void {
    _ = req;
    _ = res;
}

fn saveBook(req: *httpz.Request, res: *httpz.Response) !void {
    if (try req.json(Book)) |book| {
        std.debug.print("{any}", .{book});
    }

    try res.json(.{ .message = "saved successfully!" }, .{});
}

fn getTotal(req: *httpz.Request, res: *httpz.Response) !void {
    const no = req.param("no").?;
    const n = try std.fmt.parseInt(usize, no, 10);

    var total: u128 = 0;
    for (0..n + 1) |i| {
        total += i;
    }

    try res.json(.{ .result = total }, .{});
}

fn getUser(req: *httpz.Request, res: *httpz.Response) !void {
    // status code 200 is implicit.

    // The json helper will automatically set the res.content_type = httpz.ContentType.JSON;
    // Here we're passing an inferred anonymous structure, but you can pass anytype
    // (so long as it can be serialized using std.json.stringify)

    try res.json(.{ .id = req.param("id").?, .name = "Teg" }, .{});
}

fn notFound(_: *httpz.Request, res: *httpz.Response) !void {
    res.status = 404;

    // you can set the body directly to a []u8, but note that the memory
    // must be valid beyond your handler. Use the res.arena if you need to allocate
    // memory for the body.
    res.body = "Not Found";
}

// note that the error handler return `void` and not `!void`
fn errorHandler(req: *httpz.Request, res: *httpz.Response, err: anyerror) void {
    res.status = 500;
    res.body = "Internal Server Error";
    std.log.warn("httpz: unhandled exception for request: {s}\nErr: {}", .{ req.url.raw, err });
}
