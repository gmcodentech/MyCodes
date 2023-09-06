package main

import (
	"fmt"
	"errors"
)

func divideTwo(first float32,second float32) (float32,error){
	if second == 0.0{
		return 0.0,errors.New("divide by exception")
	}else{
		return first/second,nil
	}
}


func main(){
	res,err := divideTwo(2.2,1.5)
	if err != nil{
		fmt.Println("Error: ",err)
	} else{
		fmt.Println("Result: ",res)
	}
}

