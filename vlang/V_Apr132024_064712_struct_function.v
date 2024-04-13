//struct_function.v

struct User{
	name string
	age u8
	salary f64
}

fn (user User) get_age() u8{
	return user.age
}

fn (user User) get_salary() f64{
	return user.salary
}

fn main(){
	user := User{name:"Tom",age:28,salary:25.5}
	println(user.get_age())
	println(user.get_salary())
}