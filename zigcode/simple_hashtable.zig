const std = @import("std");
const Allocator = std.mem.Allocator;
pub fn main() !void {
	var ht = try HashTable(?u32).init(std.heap.page_allocator,10);
	defer ht.deinit();
	      
	ht.add("abc",32);
	ht.add("pqr",894);
	ht.add("xyz",932);
	ht.add("mnp",234);
	
	std.debug.print("There are {d} items\n",.{ht.count()});
	ht.delete("abc");
	std.debug.print("There are {d} items\n",.{ht.count()});

	if(ht.get("abc")) |v|{ 
		std.debug.print("{d}",.{v});
	}else{
		std.debug.print("value not found!",.{});
	}
}
      
pub fn HashTable(comptime T:type) type{
	return struct{
			arr:[]T,
			allocator:Allocator,
			const Self = @This();
			      
			fn init(allocator:Allocator,length:usize) !Self{
				var HT = Self{.allocator=allocator,.arr=try allocator.alloc(T,length)};
				for (0..length) |i|{
					HT.arr[i]=null;
				}
				return HT;
			}
			   
			//simple hashing   
			fn _getHashIndex(self:*Self,str:[]const u8) usize{
				const index = @as(usize,str[0]) % self.arr.len;				
				return index;
			}
			      
			fn add(self:*Self,key:[]const u8,val:T) void {
				const index = self._getHashIndex(key);
				self.arr[index]=val;
			}
			      
			fn get(self:*Self,key:[]const u8) T{
				const index = self._getHashIndex(key);
				return self.arr[index];
			}
			
			fn delete(self:*Self,key:[]const u8) void{
				const index = self._getHashIndex(key);
				self.arr[index]=null;
			}
			
			fn count(self:*Self) usize {
				var counter:usize = 0;
				for (self.arr) |item|{
					if(item!=null){
						counter+=1;
					}
				}
				return counter;
			}
			
			fn deinit(self:*Self) void{
				self.allocator.free(self.arr);
			}
	};
}