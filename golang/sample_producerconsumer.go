package main

import (
	"fmt"
)

func main() {
	produceChan := func() <-chan int {
		ch := make(chan int, 5)
		go func() {
			defer close(ch)
			for i := 0; i <= 5; i++ {
				ch <- i
			}
		}()
		return ch
	}

	consumeChan := func(ch <-chan int) {
		for i := range ch {
			fmt.Printf("Received: %d\n", i)
		}
		fmt.Println("Done receiving!")
	}

	ch := produceChan()
	consumeChan(ch)
}
