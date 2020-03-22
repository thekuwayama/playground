package com.example

import scalaj.http._

object Main {
  def main(args: Array[String]): Unit = {
    if (args.length != 1)
      throw new Exception("require request URL")

    val url = args(0)
    printHttpResponse(get(url))
  }

  def get(url: String): HttpResponse[String] = {
    Http(url)
      .method("GET")
      .header("content-type", "application/json")
      .timeout(connTimeoutMs = Int.MaxValue, readTimeoutMs = Int.MaxValue)
      .asString
  }

  def printHttpResponse[T](res: HttpResponse[T]): Unit = {
    println(res.statusLine)
    res.headers.foreach(kv => println(kv._1 + ": " + kv._2))
    print("\r\n")
    println(res.body.toString)
  }
}
