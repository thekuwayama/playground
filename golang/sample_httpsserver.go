package main

import (
	"io"
	"log"
	"net/http"
	"os"
)

const (
	crtPath = "./fixtures/server.crt"
	keyPath = "./fixtures/server.key"
)

func main() {
	os.Setenv("GODEBUG", os.Getenv("GODEBUG")+",tls13=1")
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		io.WriteString(w, "Hello, TLS!\n")
	})

	err := http.ListenAndServeTLS(":4433", crtPath, keyPath, nil)
	if err != nil {
		log.Fatal(err)
	}
}
