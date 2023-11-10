const std = @import("std");
 
// Define a hash table type that maps strings to integers
const StringIntMap = std.StringHashMap(i32);
 
// Create a new hash table with an allocator
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
   const allocator = gpa.allocator();
 
    var map = StringIntMap.init(allocator);
    defer map.deinit();
 
    // Insert some key-value pairs into the hash table
    try map.put("Alice", 90);
    try map.put("Bob", 80);
    try map.put("Charlie", 85);
 
    // Get the value associated with a key, or null if not found
    const alice = map.get("Alice") orelse null;
    const david = map.get("Bob") orelse null;
 
    // Print the values
    std.debug.print("Alice: {any}\n", .{alice});
    std.debug.print("David: {any}\n", .{david});
}