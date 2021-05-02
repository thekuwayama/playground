package com.example

import scala.concurrent.Await
import scala.concurrent.duration.Duration
import scala.util.{Failure, Success}

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
import akka.stream.ActorMaterializer

object Main {
  val actorSystemName = "sample_akkahttp"

  def main(args: Array[String]): Unit = {
    implicit val system       = ActorSystem(actorSystemName)
    implicit val materializer = ActorMaterializer()
    implicit val ec           = system.dispatcher

    if (args.length != 2)
      throw new Exception("require HTTP Method & request URI")

    val method = args(0) match {
      case "GET"  => HttpMethods.GET
      case "POST" => HttpMethods.POST
    }
    val entity = HttpEntity(
      ContentTypes.`application/json`,
      """{ "key": "value" }""",
    )
    val response = Await.result(
      Http().singleRequest(HttpRequest(method, uri = args(1)).withEntity(entity)),
      Duration.Inf
    )

    println(response)
  }
}
