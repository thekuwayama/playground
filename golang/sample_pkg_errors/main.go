package main

import (
	"fmt"

	"github.com/pkg/errors"
)

var anyError = errors.New("any error")

func main() {
	err := B1()
	if err != nil {
		fmt.Printf("%+v\n", err)
		return
	}

	fmt.Println("Hi!")
}

func B1() error {
	if err := B2(); err != nil {
		return errors.WithStack(err)
	}

	return nil
}

func B2() error {
	err := anyError
	if err != nil {
		return errors.WithStack(err)
	}

	return nil
}
