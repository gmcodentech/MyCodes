//ignore_values.v
fn main(){
	x,y := get_nos()
	println('$x $y')
	
	_ = x + y   //ignored
	println('done')
}

fn get_nos() (int,int){
	return 42,3
}