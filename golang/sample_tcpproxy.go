package main

import (
	"fmt"
	"net/http"

	"github.com/google/tcpproxy"
)

const (
	CRT_PATH = "./fixtures/server.crt"
	KEY_PATH = "./fixtures/server.key"
)

func serveAndRoute(s string) {
	// Listen :1180, HTTP
	// Listen :1443, HTTPS
	http.HandleFunc("/", func(rw http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(rw, s)
	})
	go http.ListenAndServe(":1180", nil)
	go http.ListenAndServeTLS(":1443", CRT_PATH, KEY_PATH, nil)

	// 127.0.0.1:2280 => 127.0.0.1:1180
	// 127.0.0.1:2443 => 127.0.0.1:1443
	var proxy tcpproxy.Proxy
	proxy.AddRoute(":2280", tcpproxy.To("127.0.0.1:1180"))
	proxy.AddRoute(":2443", tcpproxy.To("127.0.0.1:1443"))
	proxy.Run()
}

func main() {
	serveAndRoute("TEST")
}

// $ curl -i --cacert ./fixtures/ca.crt https://localhost:2443
// $ curl -i http://localhost:2280
