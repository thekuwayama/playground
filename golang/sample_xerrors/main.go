package main

import (
	"fmt"

	"golang.org/x/xerrors"
)

var anyError = xerrors.Errorf("any error")

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
		return xerrors.Errorf("%w", err)
	}

	return nil
}

func B2() error {
	err := anyError
	if err != nil {
		return xerrors.Errorf("%w", err)
	}

	return nil
}
