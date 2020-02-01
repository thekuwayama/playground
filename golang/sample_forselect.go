package main

import (
	"fmt"
	"time"
)

func main() {
	done := make(chan interface{})

	go func() {
		for {
			select {
			case <-done:
				return
			default:
				fmt.Println("Hello, for select")
				time.Sleep(1 * time.Second)
			}
		}
	}()

	time.Sleep(5 * time.Second)
	close(done)
}
