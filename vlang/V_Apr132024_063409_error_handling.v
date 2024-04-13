//error_handling.v

fn main(){
	result := div(2,0) or {
		println('Error: $err')
		return
	}
	
	println('The result is $result')
}

fn div(f int, s int) !f64{
	if s==0 {
		return error('divide by zero exception')
	}
	
	return f/f64(s)
}