//infinite_loop.v

fn main(){
	mut i := 0
	for{
		if i == 10{
			break
		}
		
		i = i + 1
	}
	
	println(' i value is $i ')
}