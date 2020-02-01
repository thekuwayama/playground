package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	wg := &sync.WaitGroup{}
	ch := make(chan string)

	wg.Add(1) // NOTE: Increment, before go
	go func(ch chan<- string) {
		defer wg.Done()
		ch <- "after receiving"
		// NOTE: the buffer length is 0, so chan is blocked until loaded
		fmt.Println("after sending")
	}(ch)

	time.Sleep(time.Second * 2)
	fmt.Println(<-ch)

	wg.Wait()
}
