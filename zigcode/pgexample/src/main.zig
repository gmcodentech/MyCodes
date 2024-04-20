//The following example used zig pg library pg.zig url - https://github.com/karlseguin/pg.zig/tree/master
const std = @import("std");
const pg = @import("pg");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var pool = try pg.Pool.init(allocator, .{ .size = 5, .connect = .{
        .port = 5432,
        .host = "127.0.0.1",
    }, .auth = .{
        .username = "postgres",
        .database = "ProductsDB",
        .password = "1234",
        .timeout = 10_000,
    } });
    defer pool.deinit();

    //insert a record
    // if(try pool.exec("insert into public.\"Products\"(name,price,units)values($1,$2,$3)",.{"Ice",100.5,500}))|no_rows_affected|{
    // std.debug.print("NO of rows affected: {d}",.{no_rows_affected});
    // }

    // //update a record
    // if(try pool.exec("update public.\"Products\" set price = $1 where id = $2",.{250.55,6})) |no_rows_updated| {
    // std.debug.print("No of rows updated: {d}",.{no_rows_updated});
    // }

    //delete a record
    // if(try pool.exec("delete from public.\"Products\" where id = $1",.{6})) |no_rows_deleted| {
    // std.debug.print("No of rows deleted: {d}",.{no_rows_deleted});
    // }

    var result = try pool.query("select id,name,price,units from public.\"Products\" where id > $1", .{0});
    defer result.deinit();
    std.debug.print("\nID - Name - Price - Units\n", .{});
    while (try result.next()) |row| {
        const id = row.get(i32, 0);
        const name = row.get([]u8, 1);
        const price = row.get(f64, 2);
        const units = row.get(i32, 3);
        std.debug.print("{d} - {s} - {d} - {d} \n", .{ id, name, price, units });
    }

    //stored procedure call
    // var sp_result = try pool.query("SELECT * FROM get_products_p()",.{});
    // defer sp_result.deinit();
    // while(try sp_result.next()) |row| {
    // std.debug.print("\n ID: {d}   Name: {s}  Price: {d}  Units: {d}",.{row.get(i32,0),row.get([]u8,1),row.get(f64,2),row.get(i32,3)});
    // }
}

//Stored procedure sql
// CREATE OR REPLACE FUNCTION get_products_p()
// RETURNS SETOF public."Products" AS $$
// BEGIN
// RETURN QUERY SELECT * FROM public."Products";
// END
// $$ LANGUAGE plpgsql;

// SELECT * FROM get_products_p();
