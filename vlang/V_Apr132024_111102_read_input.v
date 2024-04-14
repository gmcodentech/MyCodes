//read_input.v
import readline {read_line}
fn main(){
	mut total := u64(0)
	n := read_line('Enter a no: ') or {'0'}
	for i in 0..(n.u64()+1){
		total += i
	}
	println(total)
}