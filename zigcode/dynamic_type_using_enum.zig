const std = @import("std");
const print = std.debug.print;

pub fn main() !void{
	const page_id = try getModule();
	print("{d}",.{page_id});
}

fn getModule() ![]const u8 {
	var buf:[20]u8 = undefined;
	if(try read_input(&buf))|module_name|{
		const module = .{
			.type=std.meta.stringToEnum(ModuleType,module_name),
			.name=module_name,
		};
		
		return module.get_page_id();
	}
	return "";
}

const Account = struct {
	type:?ModuleType,
	name:[]const u8 = "account",
	page_id:u16=2,
	
	pub fn get_page_id(self:Account) u16 {
		return self.page_id;
	}
};
const Contact = struct {
	type:?ModuleType,
	name:[]const u8 = "contact",
	page_id:u16=1,
	
	pub fn get_page_id(self:Account) u16 {
		return self.page_id;
	}
};
const ModuleType = enum {
	NoModule,
	Account,
	Contact,
	Document,
};

fn read_input(buf:[]u8) !?[]const u8{
	
	const stdin = std.io.getStdIn();
	if(try stdin.reader().readUntilDelimiterOrEof(buf,'\n')) |line|{
		const input = std.mem.trimRight(u8, line, "\r");
		return input;
	}
	
	return null;
}