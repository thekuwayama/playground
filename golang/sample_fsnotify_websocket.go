package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/fsnotify/fsnotify"
	"golang.org/x/net/websocket"
)

func generateWsHandler(fname string) (func(*websocket.Conn), error) {
	_, err := os.Stat(fname)
	if err != nil {
		return nil, err
	}

	wsHandler := func(ws *websocket.Conn) {
		watcher, err := fsnotify.NewWatcher()
		if err != nil {
			log.Fatal(err)
		}
		defer watcher.Close()

		err = watcher.Add(".")
		if err != nil {
			log.Fatal(err)
		}

		for {
			select {
			case ev, ok := <-watcher.Events:
				if !ok {
					continue
				}
				log.Println(ev)
				if ev.Op&fsnotify.Write == fsnotify.Write && ev.Name == fname {
					s, err := getContent(fname)
					if err != nil {
						log.Printf("failed getContent %v\n", err)
						continue
					}
					ws.Write([]byte(s))
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					continue
				}
				log.Printf("failed ionotify %v\n", err)
			}
		}

	}
	return wsHandler, nil
}

func getContent(fname string) (string, error) {
	data, err := ioutil.ReadFile(fname)
	if err != nil {
		log.Fatalf("failed opening %v\n", fname)
		return "", err
	}

	return string(data), nil
}

func indexHtmlHandler(wr http.ResponseWriter, _ *http.Request) {
	html := `
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>minutes</title>
  </head>
  <body>
    <pre id="minutes"></pre>
  </body>

  <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
  <script>
    var co = $('#minutes')

    $(document).ready(function(){
      var s = $.get("initialcode", function(data) {
        co.html($('<code>').text(data));
      });
    });

    $(function() {
      var ho = window.location.host;
      var ws = new WebSocket("ws://" + ho + "/ws");
      ws.onmessage = function(e) {
        co.html($('<code>').text(event.data));
        console.log("[RECEIVE]:" + event.data);
      };
    });
  </script>
</html>
`
	fmt.Fprint(wr, html)
}

func initialCodeHandler(rw http.ResponseWriter, _ *http.Request) {
	s, err := getContent(fileName)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Fprint(rw, s)
}

var (
	fileName string
	port     int
)

func init() {
	flag.StringVar(&fileName, "f", "", "path to minutes file")
	flag.StringVar(&fileName, "fileName", "", "path to minutes file")
	flag.IntVar(&port, "p", 8080, "port number")
	flag.IntVar(&port, "port", 8080, "port number")
	flag.Parse()
}

func main() {
	_, err := os.Stat(fileName)
	if err != nil {
		log.Printf("create %s\n", fileName)
		os.Create(fileName)
	}

	wsHandler, err := generateWsHandler(fileName)
	if err != nil {
		log.Fatal(err)
	}

	http.Handle("/ws", websocket.Handler(wsHandler))
	http.Handle("/initialcode", http.HandlerFunc(initialCodeHandler))
	http.Handle("/", http.HandlerFunc(indexHtmlHandler))
	err = http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}
