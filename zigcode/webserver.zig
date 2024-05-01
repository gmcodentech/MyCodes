const std = @import("std");
const tk = @import("tokamak");
const Encoder = std.base64.standard.Encoder;
const Product = struct{
	name:[]const u8,
	price:f32,
	allocator:std.mem.Allocator,
	
	const Self = @This();
	
	fn init(allocator:std.mem.Allocator,name:[]const u8, price:f32) !*Product {
		const product = try allocator.create(Product);
		product.* = .{.name=name,.price=price,.allocator=allocator};
		return product;
	}
	
	fn deinit(self:*Self) void {
		self.allocator.destroy(self);
	}

	fn display(self:*Self) !void{
		std.debug.print("Name: {s}  Price: {d}",.{self.name,self.price});
	}
};

const Auth = struct {
	allocator:std.mem.Allocator,
	const Self = @This();
	fn init(allocator:std.mem.Allocator) !*Auth{
		const auth = try allocator.create(Auth);
		auth.* = .{.allocator=allocator};
		return auth;
	}
	
	fn deinit(self:*Self) void{
		self.allocator.destroy(self);
	}
	fn verify(self:*Self,token:[]const u8) bool{
		_ = self;
		var buffer: [0x100]u8 = undefined;
		const user_pass = "admin:1234";
		const encoded = std.base64.standard.Encoder.encode(&buffer, user_pass);
		var splits:[2][]const u8 = undefined;
		var it = std.mem.split(u8,token," ");
		var i:u8 = 0;
		while(it.next()) |s|{
			splits[i]=s;
			i+=1;
		}
		return std.mem.eql(u8,splits[1],encoded);
	}
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
	std.debug.print("server is started...\n",.{});
	
	const product = try Product.init(gpa.allocator(),".Net",50.5);
	defer product.deinit();
	//_ = product;
	
	const auth = try Auth.init(gpa.allocator());
	defer auth.deinit();
	
	const _cors = tk.Cors{.origin = "http://localhost:4200"};
    var server = try tk.Server.start(gpa.allocator(), handler, 
		.{.injector = try tk.Injector.from(.{product,auth}), 
		.port = 8080,
		.cors = _cors,
		});
    
	server.wait();
}

fn checkProduct(ctx: *tk.Context) anyerror!void {
	var product = try ctx.injector.get(*Product);
	try product.display();
	
	return ctx.next();
}

fn verifyUser(ctx: *tk.Context) anyerror!void{
	const auth = try ctx.injector.get(*Auth);
	var verified:bool = false;
	if(ctx.req.getHeader("Authorization")) |token|{	
		verified = auth.verify(token);
	}

	if(verified){
		return ctx.next();
	}else{
		std.debug.print("Failed to verify the user...\n",.{});
	}
}

const handler = tk.chain(.{
    //tk.logger(.{}),
	verifyUser,
	//checkProduct,
    tk.get("/", tk.send("Hello")),
	
    tk.group("/api", tk.router(api)),
    tk.send(error.NotFound),
});

// fn auth(ctx: *Context) anyerror!void {
    // // const db = ctx.injector.get(*Db);
    // const token = try jwt.parse(ctx.req.getHeader("Authorization"));
    // //const user = db.find(User, token.id) catch null;

    // //ctx.injector.push(&user);

    // return ctx.next();
// }

const api = struct {
    pub fn @"GET /"() []const u8 {
        return "Hello";
    }

    pub fn @"GET greet/:name"(allocator: std.mem.Allocator, name: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "Hello {s}", .{name});
    }
	
	pub fn @"GET total/:n"(allocator:std.mem.Allocator,n:u64) ![]const u8{
		var total:u128=0;
		for(0..n+1) |i|{
			total += i;
		}
		return std.fmt.allocPrint(allocator, "{d}", .{total});
	}
	
	pub fn @"GET /books/:count"(allocator: std.mem.Allocator,res: *tk.Response,count:u8) !void {

		var list =try allocator.alloc(Book,count);
		defer allocator.free(list);
		for (0..count) |c|{
		list[c]=Book{.title=".NET",.pages=23,.price=23.5};
		
		}
		
		try res.send(list);
	}
	
	pub fn @"POST save/"(allocator: std.mem.Allocator,res: *tk.Response,data:Book) !void {
		_=allocator;
		std.debug.print("received: {any}\n\n",.{data});
        try res.send(.{.message="saved successfully!"});
    }
};



const Book = struct{
	title:[]const u8,
	price:f32,
	pages:u32,
};