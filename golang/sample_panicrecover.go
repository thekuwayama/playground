package main

import (
	"fmt"
)

func main() {
	defer func() { // like try-catch
		err := recover()
		fmt.Printf("recover: %v\n", err)
	}()

	fmt.Println("before panic")
	panic("panic")
	fmt.Println("after panic") // NOTE: do not reach here
}
