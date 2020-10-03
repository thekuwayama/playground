package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

const (
	validUser = "TestUser"
	validPass = "TestPassword"
)

func basicAuthHandler(wr http.ResponseWriter, r *http.Request) {
	user, pass, ok := r.BasicAuth()
	if !ok || user != validUser || pass != validPass {
		wr.Header().Add("WWW-Authenticate", `Basic realm="apps"`)
		wr.WriteHeader(http.StatusUnauthorized)
		http.Error(wr, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
		return
	}

	_, err := fmt.Fprintf(wr, "OK\n")
	if err != nil {
		log.Fatal(err)
	}
}

var (
	port int
)

func init() {
	flag.IntVar(&port, "p", 8080, "port number")
	flag.IntVar(&port, "port", 8080, "port number")
	flag.Parse()
}

func main() {
	http.Handle("/", http.HandlerFunc(basicAuthHandler))
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}

// go run sample_ws_server.go &
// curl -u TestUser:TestPassword http://localhost:8080/
