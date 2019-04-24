package main

import (
	"io"
	"log"
	"net/http"
)

const (
	crtPath = "./fixtures/server.crt"
	keyPath = "./fixtures/server.key"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		io.WriteString(w, "Hello, TLS!\n")
	})

	err := http.ListenAndServeTLS(":4433", crtPath, keyPath, nil)
	if err != nil {
		log.Fatal(err)
	}
}
