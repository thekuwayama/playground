package main

import (
	"crypto/tls"
	"encoding/base64"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func main() {
	log.SetFlags(log.Lshortfile)

	// https://dns.google/query?name=research.cloudflare.com&rr_type=HTTPS
	args := os.Args
	if len(args) != 2 {
		log.Fatal("Requires exactly 1 argument.")
	}

	echConfigList, err := base64.StdEncoding.DecodeString(args[1])
	if err != nil {
		log.Fatalf("Decode base64 string %s: %v", args[1], err)
	}

	config := &tls.Config{
		EncryptedClientHelloConfigList: echConfigList,
		ServerName:                     "research.cloudflare.com",
	}

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: config,
		},
	}

	url := "https://research.cloudflare.com/cdn-cgi/trace"
	resp, err := client.Get(url)
	if err != nil {
		log.Fatalf("GET request to %s: %v", url, err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Read HTTP Response: %v", err)
	}

	fmt.Print(string(body))
}

// $ go run sample_ech_client.go AEX+DQBBawAgACBRVO1kCb5b2znHUOTe+L42PHgEjBSNt4LD/qDNxffkAgAEAAEAAQASY2xvdWRmbGFyZS1lY2guY29tAAA=
