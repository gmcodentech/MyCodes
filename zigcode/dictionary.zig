const std = @import("std");
const Allocator = std.mem.Allocator;
   
pub fn main() !void{
	const allocator = std.heap.page_allocator;
	   
	const DictionaryInt = Dictionary(i32);
	var dictionary = DictionaryInt.init(allocator);
	defer dictionary.deinit();
	   
	try dictionary.add("abc",23);
	try dictionary.add("pqr",190);
	   
	const v = dictionary.get("sdf") orelse -1;
	   
	std.debug.print("{d}",.{v});
	
	std.debug.print("\nDictionary Length: {d}",.{dictionary.len()});

}
 
fn Dictionary(comptime T:type) type {
	return struct {
	const Self = @This();
	   
	 
	list:std.ArrayList(KeyValue),
	   
	const KeyValue = struct{
		key:[]const u8,
		value:T
	};
	   
	fn init(allocator:Allocator) Self{
		return Self{.list = std.ArrayList(KeyValue).init(allocator)};
	}
	   
	fn deinit(self:*Self) void {
		self.list.deinit();
	}
	   
	fn add(self:*Self,key:[]const u8,value:T) !void{
		if(self.get(key)!=null) {
			return error.KeyAlreadyExists;
		}
		try self.list.append(.{.key=key,.value=value});
	}
	   
	fn get(self:*Self,key:[]const u8) ?T{
		for (self.list.items) |kv|{
			if(std.mem.eql(u8,kv.key,key)){
				return kv.value;
			}
		}
		   
		return null;
	}
	
	fn len(self:*Self) usize{
		return self.list.items.len;
	}

  };
}


//tests
test "dictionary tests"{
	var dictionary = Dictionary(u32).init(std.testing.allocator);
	defer dictionary.deinit();
	
	try dictionary.add("abc",23);
	const val = dictionary.get("abc").?;
	try std.testing.expect(val==23);
}

test "dictionary already exists"{
	var dictionary = Dictionary(u32).init(std.testing.allocator);
	defer dictionary.deinit();
	
	try dictionary.add("abc",23);	
	try std.testing.expect(dictionary.add("abc",234)==error.KeyAlreadyExists);

}

test "dictionary length"{
	var dictionary = Dictionary(u32).init(std.testing.allocator);
	defer dictionary.deinit();
	
	try dictionary.add("abc",23);	
	try dictionary.add("xyz",235);
	try dictionary.add("mnp",23);
	
	try std.testing.expect(dictionary.len()==3);

}