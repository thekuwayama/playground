package main

import (
	"fmt"
)

func erase(slice []string, i int) {
	if len(slice) <= i {
		// fmt.Printf("len(slice): %d\n", len(slice))
		// fmt.Printf("i:          %d\n", i)
		return
	}

	slice = append(slice[:i], slice[i+1:]...)
	fmt.Printf("inner %v\n", slice)

	return
}

// NOTE: https://tour.golang.org/moretypes/8
func main() {
	slice := []string{"1", "2", "3"}
	erase(slice, 0)

	fmt.Printf("outer %v\n", slice)
}
