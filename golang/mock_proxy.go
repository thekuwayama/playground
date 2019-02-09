package main

import (
	"fmt"
	"net/http"
	"net/url"
)

type mockProxy struct {
	calledProxyMockFunc bool
}

func (m *mockProxy) resetMockProxyCheck() {
	m.calledProxyMockFunc = false
}

func (m *mockProxy) mockProxyFunc() func(req *http.Request) (*url.URL, error) {
	return func(req *http.Request) (*url.URL, error) {
		m.calledProxyMockFunc = true
		return nil, nil
	}
}

func main() {
	m := mockProxy{}
	m.resetMockProxyCheck()

	client := http.DefaultClient
	client.Transport = &http.Transport{
		Proxy: m.mockProxyFunc(),
	}
	req, _ := http.NewRequest("GET", "http://localhost:8000/", nil)

	_, err := client.Do(req)
	if err != nil {
		panic("faild http request.")
	}
	fmt.Println(m.calledProxyMockFunc) // => true
	m.resetMockProxyCheck()
}

// $ ruby -run -e httpd . -p 8000 &
// $ go run mock_proxy.go
// $ fg
// #Ctrl-C
