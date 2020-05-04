package main

import (
	"flag"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
)

func wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer conn.Close()

	s := `[
          {"depth": 1, "ancestors": [], "name": "A1"},
          {"depth": 1, "ancestors": [], "name": "a1"}
        ]`
	if err = websocket.WriteJSON(conn, s); err != nil {
		log.Println(err)
		return
	}

	d := rand.Intn(1000)
	time.Sleep(time.Duration(d) * time.Millisecond)
	s = `[
          {"depth": 2, "ancestors": ["A1"], "name": "B1"},
          {"depth": 2, "ancestors": ["a1"], "name": "b1"}
        ]`
	if err = websocket.WriteJSON(conn, s); err != nil {
		log.Println(err)
		return
	}

	d = rand.Intn(1000)
	time.Sleep(time.Duration(d) * time.Millisecond)
	s = `[
          {"depth": 3, "ancestors": ["A1", "B1"], "name": "C1"},
          {"depth": 3, "ancestors": ["a1", "b1"], "name": "c1"}
        ]`
	if err = websocket.WriteJSON(conn, s); err != nil {
		log.Println(err)
		return
	}
}

var (
	port     int
	upgrader websocket.Upgrader
)

func init() {
	flag.IntVar(&port, "p", 8080, "port number")
	flag.IntVar(&port, "port", 8080, "port number")
	flag.Parse()

	upgrader = websocket.Upgrader{}
}

func main() {
	http.HandleFunc("/", wsHandler)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("error starting http server::", err)
		return
	}
}

// $ go get github.com/gorilla/websocket
// $ npm install -g wscat
// $ go run sample_ws_server.go &
// $ wscat -c localhost:8080/
