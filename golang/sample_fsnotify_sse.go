package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/fsnotify/fsnotify"
)

func generateSseHandler(fname string) (func(http.ResponseWriter, *http.Request), error) {
	_, err := os.Stat(fname)
	if err != nil {
		return nil, err
	}

	sseHandler := func(rw http.ResponseWriter, _ *http.Request) {
		rw.Header().Set("Content-Type", "text/event-stream")
		rw.Header().Set("Cache-Control", "no-cache")
		rw.Header().Set("Connection", "keep-alive")
		flusher, ok := rw.(http.Flusher)
		if !ok {
			log.Print("failed #(http.Flusher)")
		}
		flusher.Flush()

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

					fmt.Fprintf(rw, "data: %s\n\n", strings.ReplaceAll(s, "\n", "\ndata: "))
					flusher.Flush()
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					continue
				}
				log.Printf("failed ionotify %v\n", err)
			}
		}

	}
	return sseHandler, err
}

func getContent(fname string) (string, error) {
	data, err := ioutil.ReadFile(fname)
	if err != nil {
		log.Fatalf("failed opening %v\n", fname)
		return "", err
	}

	return string(data), nil
}

func generateIndexHandler(fname string) (func(http.ResponseWriter, *http.Request), error) {
	_, err := os.Stat(fname)
	if err != nil {
		return nil, err
	}

	s, err := getContent(fname)
	if err != nil {
		return nil, err
	}
	html := `
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>minutes</title>
    <script>
      window.onload = function() {
        var source = new EventSource("sse");
        source.onmessage = function(e) {
          document.getElementById("minutes").innerText = e.data
        };
      };
    </script>
  </head>

  <body>
    <pre><code id="minutes">%s</code></pre>
  </body>
</html>
`
	indexHandler := func(rw http.ResponseWriter, _ *http.Request) {
		fmt.Fprint(rw, fmt.Sprintf(html, s))
	}

	return indexHandler, nil
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

	sseHandler, err := generateSseHandler(fileName)
	if err != nil {
		log.Fatal(err)
	}
	indexHandler, err := generateIndexHandler(fileName)
	if err != nil {
		log.Fatal(err)
	}

	http.Handle("/sse", http.HandlerFunc(sseHandler))
	http.Handle("/", http.HandlerFunc(indexHandler))
	err = http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}
