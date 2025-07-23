const std = @import("std");
pub fn main() !void{
	//try getPassword();
	const ch:u8 = try getch();
	std.debug.print("{c}",.{ch});
}

fn getPassword() !void{
	var password:[20]u8 = undefined;
	std.debug.print("Password:",.{});
	var i: usize = 0;
	while (true) : (i += 1) {
		password[i]=try getch(); 
        if(password[i]!='\r'){ 
            std.debug.print("{c}",.{'*'}); 
        } 
		else{
			break;
		}
	}

	//std.debug.print("Your password is {s}",.{password});
}


fn getch() !u8{	
	const stdin = std.io.getStdIn();
	const b:u8 = try stdin.reader().readByte();
	//std.debug.print("{c}\\b",.{0x08}); 
	return b;
}