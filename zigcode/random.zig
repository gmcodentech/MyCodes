const std = @import("std");

pub fn main() !void{
	const d = try getRandomInt();
	std.debug.print("{d}",.{d});
}

fn getRandomInt() !u64{
	 var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
	
	// const a = rand.float(f32);
    // const b = rand.boolean();
	// const n = rand.int(u8);
	return rand.intRangeAtMost(u64, 0, 1000);
}