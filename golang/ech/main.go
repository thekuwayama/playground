package main

import (
	"bufio"
	"crypto/aes"
	"crypto/cipher"
	"crypto/ecdh"
	"crypto/rand"
	"crypto/tls"
	"encoding/base64"
	"fmt"
	"log"
	"net"
	"os"

	"golang.org/x/crypto/cryptobyte"
)

const (
	crtPath = "../../fixtures/server.crt"
	keyPath = "../../fixtures/server.key"
)

var SupportedAEADs = []uint16{
	// RFC 9180, Section 7.3
	0x0001, // AEAD_AES_128_GCM
	0x0002, // AEAD_AES_256_GCM
	0x0003, // AEAD_ChaCha20Poly1305
}

var aesGCMNew = func(key []byte) (cipher.AEAD, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	return cipher.NewGCM(block)
}

func marshalECHConfig(id uint8, pubKey []byte, publicName string, maxNameLen uint8) []byte {
	const extensionEncryptedClientHello uint16 = 0xfe0d

	builder := cryptobyte.NewBuilder(nil)
	builder.AddUint16(extensionEncryptedClientHello)
	builder.AddUint16LengthPrefixed(func(builder *cryptobyte.Builder) {
		builder.AddUint8(id)
		builder.AddUint16(0x0020) // DHKEM_X25519_HKDF_SHA256 // The only DHKEM we support
		builder.AddUint16LengthPrefixed(func(builder *cryptobyte.Builder) {
			builder.AddBytes(pubKey)
		})
		builder.AddUint16LengthPrefixed(func(builder *cryptobyte.Builder) {
			for _, aeadID := range SupportedAEADs {
				builder.AddUint16(0x0001) // KDF_HKDF_SHA256 // The only KDF we support
				builder.AddUint16(aeadID)
			}
		})
		builder.AddUint8(maxNameLen)
		builder.AddUint8LengthPrefixed(func(builder *cryptobyte.Builder) {
			builder.AddBytes([]byte(publicName))
		})
		builder.AddUint16(0) // extensions
	})

	return builder.BytesOrPanic()
}

func marshalECHConfigs(echConfig []byte) []byte {
	builder := cryptobyte.NewBuilder(nil)

	// ECHConfig ECHConfigList<4..2^16-1>;
	// https://datatracker.ietf.org/doc/html/draft-ietf-tls-esni-22#section-4-10
	builder.AddUint16(uint16(len(echConfig)))
	builder.AddBytes(echConfig)

	return builder.BytesOrPanic()
}

func tmpECHConfigPEM(echConfigs []byte) (string, error) {
	tmpFile, err := os.CreateTemp("/tmp", "echconfigs.pem")
	if err != nil {
		return "", err
	}
	defer tmpFile.Close()

	if _, err := tmpFile.WriteString(fmt.Sprintf("-----BEGIN ECHCONFIG-----\n%s\n-----END ECHCONFIG-----", base64.StdEncoding.EncodeToString(echConfigs))); err != nil {
		return "", err
	}

	return tmpFile.Name(), nil
}

func main() {
	log.SetFlags(log.Lshortfile)

	ck, err := tls.LoadX509KeyPair(crtPath, keyPath)
	if err != nil {
		log.Println(err)
		return
	}

	echKey, err := ecdh.X25519().GenerateKey(rand.Reader)
	if err != nil {
		log.Println(err)
		return
	}

	echConfig := marshalECHConfig(123, echKey.PublicKey().Bytes(), "localhost", 32)
	echConfigs := marshalECHConfigs(echConfig)
	fname, err := tmpECHConfigPEM(echConfigs)
	if err != nil {
		log.Println(err)
		return
	}
	log.Println(fname)

	config := &tls.Config{
		Certificates: []tls.Certificate{ck},
		EncryptedClientHelloKeys: []tls.EncryptedClientHelloKey{
			{
				Config:      echConfig,
				PrivateKey:  echKey.Bytes(),
				SendAsRetry: true,
			},
		},
	}
	ln, err := tls.Listen("tcp", ":4433", config)
	if err != nil {
		log.Println(err)
		return
	}
	defer ln.Close()

	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Println(err)
			continue
		}
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	defer conn.Close()
	r := bufio.NewReader(conn)
	for {
		msg, err := r.ReadString('\n')
		if err != nil {
			log.Println(err)
			return
		}

		log.Println(msg)

		n, err := conn.Write([]byte("hello, world\n"))
		if err != nil {
			log.Println(n, err)
			return
		}
	}
}

// $ git clone git@github.com:golang/go.git
// $ cd go/src
// $ git checkout go1.24rc1
// $ ./make.bash
// $ ../..
// $ GOROOT='' ./go/bin/go version #=> go version go1.24rc1 darwin/arm64
// $ GOROOT='' ./go/bin/go run main.go

// $ls /tmp | grep echconfigs.pem  #=> echconfigs.pem**
