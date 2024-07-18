const std = @import("std");
const NumError = error{IllegalNo,InvalidNo};

//This will not work as there is an error of undefined item in the error list
pub fn main() !void{
	const x = 0;
	if(x==0){
		return NumError.NoNumber;
	}else{
		return NumError.IllegalNo;
	}
	
	std.debug.print("dn",.{});
}

