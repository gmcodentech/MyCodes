const std = @import("std");
const print = std.debug.print;
const DB = @import("DB.zig").DB;

pub fn main() !void{
	var dbg = std.heap.DebugAllocator(.{}){};
	defer _ = dbg.deinit(); 
	const allocator = dbg.allocator();

	// const rice = try allocator.dupe(u8,"Rice");
	// defer allocator.free(rice);
	// const id = try allocator.dupe(u8,"100");
	// defer allocator.free(id);
	
	var db = DB(Product).init(allocator,"catalog");
	defer db.deinit();
	
	// const saved_response = try db.create(.{.name=rice,.price=234.5,.units=1009});
	// print("\nok:{} id:{s} rev:{s}",.{saved_response.ok,saved_response.id,saved_response.rev});

	const products = try db.getList();
	for(products) |p|{
		print("\n{s} {d} {d} {s} {s}",.{p.name,p.price,p.units,p._id,p._rev});
		//_=try db.delete(p);
	}
	 print("done!",.{});
	 //const item_id = try allocator.dupe(u8,"9170c682dd835642f5bb7521a800347d");
	 //defer allocator.free(item_id);
	 //const product = try db.getById(item_id);
	 	 
	 
	 // const wheat = try allocator.dupe(u8,"Wheat");
	 // defer allocator.free(wheat);
	 
	// const wheat_id = try allocator.dupe(u8,"9170c682dd835642f5bb7521a800abed");
	// defer allocator.free(wheat_id);
	
	// const wheat_rev= try allocator.dupe(u8,"2-3dc2fb6b63f92807be695889fd16f950");
	// defer allocator.free(wheat_rev);
	// const resp = try db.delete(Product{._id=wheat_id,._rev=wheat_rev,.name=wheat,.price=2345.6,.units=156});
	// print("{any}",.{resp});
	//_ = try db.update(Product{._id=wheat_id,._rev=wheat_rev,.name=wheat,.price=2345.6,.units=156});
}




const User = struct{
	_id: []u8,
    _rev: []u8,
	power:u32,
};

const Product = struct{
	_id: []u8,
    _rev: []u8,
	name: []u8,
	price: f32,
	units:i32=0,
};

