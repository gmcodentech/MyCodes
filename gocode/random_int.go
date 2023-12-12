package main

import (
	"fmt"
	"math/rand"
)

func main(){
	var n = 45
	var r = rand.Intn(n)
	fmt.Println(n,"=", r, "+",n-r)	
}