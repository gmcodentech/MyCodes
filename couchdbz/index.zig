const std = @import("std");
const print = std.debug.print;
const couch = @import("DB.zig");
const DB = couch.DB;
const Info = couch.Info;
pub fn main() !void {
    var dbg = std.heap.DebugAllocator(.{}){};
    defer _ = dbg.deinit();
    const allocator = dbg.allocator();

	//try testProduct(allocator);
    try testUser(allocator);
    print("\ndone!", .{});
}

fn testUser(allocator:std.mem.Allocator)!void{
	var db = DB(User).init(allocator,"crm","admin","admin");
	defer db.deinit();
	
	// const metadata:Info = try db.getDbMetadata();
	// print("Total documents: {d}",.{metadata.doc_count});
	
	// const list = try db.getList(3);
	// for(list) |u|{
		// print("\nType:{s} id:{s} Power:{d}",.{u.type,u._id,u.power});
	// }
	
	// const db_exists = try db.checkForDb("crm");
	// if(!db_exists){
		// print("database does not exist. created the db.\n",.{});
		// _ = try db.createDb();
	// }
	
	// const id = try allocator.dupe(u8,"0");
    // defer allocator.free(id);
	// for(1..1000)|i|{
		// const r = 1 + i;
		// const saved_response = try db.create(.{.type="user",.power=r});
		// _ = saved_response;
	// }
	// if(saved_response.ok){
		// print("\nUser saved!",.{});
	// }
	
	
	const mangoQuery=.{.selector=.{.type="user"},.limit=100};
	const users = try db.search(mangoQuery);
	print("\nTotal Users: {d}",.{users.len});
	
	// for(users) |u|{
		// print("\n{s} {d}",.{u.type,u.power});
	// }
}

fn testProduct(allocator:std.mem.Allocator)!void{
	// const rice = try allocator.dupe(u8,"Rice");
    // defer allocator.free(rice);
    // const id = try allocator.dupe(u8,"100");
    // defer allocator.free(id);

    var db = DB(Product).init(allocator, "catalog","admin","admin");
    defer db.deinit();

    // const saved_response = try db.create(.{.name=rice,.price=234.5,.units=1009});
    // print("\nok:{} id:{s} rev:{s}",.{saved_response.ok,saved_response.id,saved_response.rev});

    const products = try db.getList();
    for(products) |p|{
    print("\n{s} {d} {d} {s} {s}",.{p.name,p.price,p.units,p._id,p._rev});
    //_=try db.delete(p);
    }

    // const item_id = try allocator.dupe(u8,"6567c71c7fff67cdaf6384891c005ab8");
    // defer allocator.free(item_id);
    // const product = try db.getById(item_id);

    // print("{any}",.{product});

    // const wheat = try allocator.dupe(u8, "Wheat");
    // defer allocator.free(wheat);

    // const wheat_id = try allocator.dupe(u8, "6567c71c7fff67cdaf6384891c005ab8");
    // defer allocator.free(wheat_id);

    // const wheat_rev = try allocator.dupe(u8, "2-3dc2fb6b63f92807be695889fd16f950");
    // defer allocator.free(wheat_rev);

    // //_ = try db.update(Product{._id=wheat_id,._rev=wheat_rev,.name=wheat,.price=2345.6,.units=156});

    // const resp = try db.delete(Product{ ._id = wheat_id, ._rev = wheat_rev, .name = wheat, .price = 2345.6, .units = 156 });
    // print("{any}", .{resp});
}

const User = struct {
    _id: []u8,
    _rev: []u8,
	type:[]u8,
    power: u32,
};

const Product = struct {
    _id: []u8,
    _rev: []u8,
	type:[]u8,
    name: []u8,
    price: f32,
    units: i32 = 0,
};
