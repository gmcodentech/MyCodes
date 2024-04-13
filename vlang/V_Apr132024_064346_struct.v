//struct.v

struct User{
	name string
	age u8
	salary f64
}

fn main(){
	user := User{
		name : "Scott",age : 32, salary : 144.2
	}
	
	println(user.name)
}