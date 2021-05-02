import Dependencies._

ThisBuild / scalaVersion     := "2.12.8"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

val AkkaVersion = "2.6.14"

lazy val root = (project in file("."))
  .settings(
    name := "sample_akkahttp",
    libraryDependencies ++= Seq(
      scalaTest % Test,

      "com.typesafe.akka" %% "akka-stream" % "2.6.14",
      "com.typesafe.akka" %% "akka-http"   % "10.2.4"
    )
  )
