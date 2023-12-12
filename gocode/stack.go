package main
 
import (
	"fmt"
	"errors"
)
 
type Stack[T any] struct{
	stack []T
}
 
func (stack *Stack[T]) Push(item T){
	if(len(stack.stack)==0){
		stack.stack = make([]T,0,50)
	}
	 
	stack.stack = append(stack.stack,item)
}

func (stack *Stack[T]) Pop() (T,error){
	
	if stack.isEmpty(){
		var zero T
		return zero,errors.New("Empty Stack Error")
	}
	index := len(stack.stack)-1
	val := stack.stack[index]
	stack.stack = stack.stack[:index]
	return val,nil
}

func (stack *Stack[T]) isEmpty() bool{
	return len(stack.stack)==0
}

func (stack *Stack[T]) Top() T{
	index := len(stack.stack)-1
	return stack.stack[index]
}
 
func (stack *Stack[T]) Count() int{
	return len(stack.stack)
}
func main(){
	var stack *Stack[int] = &Stack[int]{}
	stack.Push(10)
//	stack.Push(40)
//	stack.Push(435)
//	stack.Push(45)
	fmt.Println(stack.Count())
	res,err := stack.Pop()
	fmt.Println(res)
	//fmt.Println(stack.Top())
	v,err := stack.Pop()
	if err != nil{
		fmt.Println(err)
	}
	
	fmt.Println(v)
}