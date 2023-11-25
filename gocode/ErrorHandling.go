package main

import (
	"fmt"
	"errors"
)

func main(){
	value,err := GetNo()
	if(err!=nil){
		fmt.Println("Err:",err)
	}else{
		fmt.Println("Value:",value)
	}
}

func GetNo() (int,error){
	const x int = -1

	if(x < -1){
		return x, errors.New("Received a negative no")
	}else{
		return x, nil
	}
}