package main

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/aws/aws-sdk-go/aws/awserr"
	"golang.org/x/xerrors"
)

func main() {
	e1 := xerrors.Errorf("wrap: %w", sql.ErrNoRows)
	if errors.Is(e1, sql.ErrNoRows) {
		fmt.Println("errors.Is(e1, sql.ErrNoRows): true")
	}

	e2 := xerrors.Errorf("wrap: %w", awserr.New("code", "message", errors.New("origin")))
	var awsErr awserr.Error
	if errors.As(e2, &awsErr) {
		fmt.Println("errors.As(e2, &awsErr): true")
		fmt.Printf("%v\n", awsErr)
	}
}
