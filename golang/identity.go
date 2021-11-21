package main

import (
	"fmt"
)

// id
func indentity(x int) int {
	return x
}

// f
func inc(x int) int {
	return x + 1
}

func main() {
	fmt.Printf("f . id: %d\n", inc(indentity(0)))
	fmt.Printf("id . f: %d\n", indentity(inc(0)))
}
