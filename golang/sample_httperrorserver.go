package main

import (
	"fmt"
	"net/http"
	"os"
)

func ErrorHttpResponse(w http.ResponseWriter, _r *http.Request) {
	http.Error(w, "{\"error\":{\"code\":1,\"description\":\"sample\"}}", http.StatusBadRequest)
}

func main() {
	http.HandleFunc("/", ErrorHttpResponse)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: starting http server %v", err)
		return
	}
}
