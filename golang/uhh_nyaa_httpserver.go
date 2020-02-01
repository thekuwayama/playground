package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

func indexHtmlHandler(wr http.ResponseWriter, _ *http.Request) {
	html := `
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>うー！　にゃー！</title>
    <style type="text/css">
      pre {
        display: none;
        font-size: 200%;
      }
      pre.visible {
        display: block;
      }
    </style>
  </head>
  <body>
    <pre>
(」・ω・)」うー！
    </pre>
    <pre>
(／・ω・)／にゃー！
    </pre>
    <pre>
(」・ω・)」うー！
    </pre>
    <pre>
(／・ω・)／にゃー！
    </pre>
  </body>

  <script>
    var container = document.body;
    var index = 0;
    function update() {
      container.children[index].className = "";
      index = (index + 1) % container.children.length;
      container.children[index].className = "visible";
    }
    setInterval(update, 1000);
  </script>
</html>
`
	fmt.Fprint(wr, html)
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
	http.Handle("/", http.HandlerFunc(indexHtmlHandler))
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}
