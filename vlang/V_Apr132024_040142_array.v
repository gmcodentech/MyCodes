//array.v
fn main(){
	arr := [1,2,3,4,5,6,7]
	println(arr[0])
	println(arr)
	
	mut arr1 := [1,2,3]
	arr1[2]=13
	println(arr1)
	
	arr1 << 14
	println(arr1)
	
	slc := arr[1...3]
	println(slc)
}