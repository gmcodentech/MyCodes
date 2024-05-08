const std = @import("std");
     
pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	const allocator = gpa.allocator();
	
	const listInt = LinkedList(u32);
	var list = listInt.init(allocator);
	defer list.deinit();
	try list.add(43);
	try list.add(90);
	try list.add(8);
	std.debug.print("{d}\n",.{list.len()});
	list.remove(90);
	list.remove(43);
	try list.add(950);
	std.debug.print("{d}\n",.{list.len()});
	const found = list.search(950);
	std.debug.print("Found {any}\n",.{found});
}
     
fn LinkedList(comptime T:type) type {
	return struct{
		const Node = struct{
			data:T,
			next:?*Node=null,
		};
		
		allocator:std.mem.Allocator,
		     
		first:?*Node=null,
		     
		const Self = @This();
		     
		fn init(allocator:std.mem.Allocator) Self{
			return Self{.allocator=allocator};
		}
		
		fn deinit(self:*Self) void{
			var it = self.first;
			while(it) |node|{
				const next = node.next;
				self.allocator.destroy(node);
				it = next;				
			}
		}
				     
		fn add(self:*Self,value:T) !void{
			const new_node = try self.allocator.create(Node);
			new_node.*= .{.data=value,.next = self.first};
			self.first = new_node;
			std.debug.print("added {d}\n",.{value});
		}
		
		fn search(self:*Self,value:T) bool{
			var it = self.first;
			while(it) |node|{
				if(node.data == value){
					return true;
				}
				it = node.next;
			}
			
			return false;
		}
		
		
		fn remove(self:*Self,value:T) void{
			var it = self.first;
			var prev = self.first;
			while(it) |node|{
				const next = node.next;
				if(node.data == value){
					std.debug.print("removing... {d}\n",.{node.data});
					self.allocator.destroy(node);
					prev.?.next = next;
				}
				
				it = next;
			}
		}
		     
		fn len(self:*Self) usize{
			var counter:usize = 0;
			var it = self.first;
			while(it) |node| {
				counter += 1;
				it = node.next;
			}
			     
			return counter;
		}
     
	};
}
     
     