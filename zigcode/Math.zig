first:i32 = undefined,
second:i32 = undefined,

const Self = @This();

pub fn init(f:i32,s:i32) Self{
	return Self{.first=f,.second=s};
}

pub fn add(self:*Self) i32{
	return self.first + self.second;
}