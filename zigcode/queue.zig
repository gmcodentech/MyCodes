const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn main() !void{
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = gpa.deinit();
	
	const IntQueue = Queue(i32);
	var queue = IntQueue.init(gpa.allocator());
	defer queue.deinit();
	
	try queue.enqueue(90);
	try queue.enqueue(23);
	try queue.enqueue(-2);
	
	std.debug.print("{d}",.{queue.count()});
	const v = queue.dequeue().?;
	std.debug.print("\nvalue = {d}",.{v});
	const v2 = queue.dequeue().?;
	std.debug.print("\nvalue = {d}",.{v2});

	std.debug.print("\n{d}",.{queue.count()});
}

pub fn Queue(comptime T:type) type{
	return struct{
		queue:ArrayList(T),
		
		const Self = @This();
		
		fn init(allocator:Allocator) Self{
			return Self{.queue=ArrayList(T).init(allocator)};
		}
		fn enqueue(self:*Self,val:T) !void {
			try self.queue.append(val);
		}
		
		fn dequeue(self:*Self) ?T{
			if(self.count()>0){
				const first = self.queue.items[0];
				for (1..self.queue.items.len) |index| {
					self.queue.items[index-1] = self.queue.items[index];					
				}
				_ = self.queue.pop();
				return first;
			}
			
			return null;
		}
		fn count(self:*Self) usize {
			return self.queue.items.len;
		}
		
		fn deinit(self:*Self) void {
			self.queue.deinit();
		}
		
	};
}