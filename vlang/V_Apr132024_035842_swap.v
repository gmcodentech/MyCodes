//swap.v
fn main(){
	mut a, mut b := 12,49
	println('Before : a=$a and b=$b')
	a,b = b,a
	println('After : a=$a and b=$b')
}