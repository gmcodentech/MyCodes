package main

import (
	"fmt"
	_ "sync"
)

func main(){
	// var wg sync.WaitGroup
	
	// values := []int {1,2,3,4,5}
	// for _,val := range values{
		// wg.Add(1)
		// go func(){		
			// fmt.Println(val)
			// wg.Done()
		// }()
	// }
	
	// wg.Wait()
	
	for i:= range 5{
		fmt.Println(i)
	}
}