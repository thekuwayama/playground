package main

import (
	"fmt"
	"math/rand"
	"time"
)

const (
	lowerLetters = "abcdefghijklmnopqrstuvwxyz"
	upperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	numbers      = "0123456789"
)

func genMyRandString(len int) (string, error) {
	if len < 3 {
		return "", fmt.Errorf("password MUST be more than 3 characters long.")
	}

	rand.Seed(time.Now().UnixNano())
	x := rand.Intn(len - 2)
	y := rand.Intn(len - 2)
	var sep1 int
	var sep2 int
	if x <= y {
		sep1 = x
		sep2 = y + 1
	} else {
		sep1 = y
		sep2 = x + 1
	}

	buf := make([]byte, len)
	for i := 0; i <= sep1; i += 1 {
		j := rand.Intn(26)
		buf[i] = lowerLetters[j]
	}
	for i := sep1 + 1; i <= sep2; i += 1 {
		j := rand.Intn(26)
		buf[i] = upperLetters[j]
	}
	for i := sep2 + 1; i < len; i += 1 {
		j := rand.Intn(10)
		buf[i] = numbers[j]
	}

	rand.Shuffle(len, func(i, j int) { buf[i], buf[j] = buf[j], buf[i] })

	return string(buf), nil
}

func main() {
	passwd, err := genMyRandString(16)
	if err != nil {
		panic(err)
	}

	fmt.Println(passwd)
}
