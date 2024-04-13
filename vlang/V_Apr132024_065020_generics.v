//generics.v

fn add_two<T> ( first T, second T) T{
	return first + second
}

fn main(){
	println(add_two(2.3,4.3))
	println(add_two(12,34))
	println(add_two('Hello',' World'))
}