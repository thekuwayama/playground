package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"

	"golang.org/x/crypto/hkdf"
)

func main() {
	ikm, _ := hex.DecodeString("7df235f2031d2a051287d02b0241b0bfdaf86cc856231f2d5aba46c434ec196c")
	info, _ := hex.DecodeString("002010746c73313320726573756d7074696f6e020000")
	out := make([]byte, 32)
	hkdf.Expand(sha256.New, ikm, info).Read(out)
	fmt.Println(out)

	ikm, _ = hex.DecodeString("0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
	info, _ = hex.DecodeString("")
	out = make([]byte, 42)
	hkdf.Expand(sha256.New, ikm, info).Read(out)
	fmt.Println(out)
}
