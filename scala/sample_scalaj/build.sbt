import Dependencies._

ThisBuild / scalaVersion     := "2.12.8"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

lazy val root = (project in file("."))
  .settings(
    name := "sample_scalaj",
    libraryDependencies += scalaTest % Test,
    libraryDependencies +=  "org.scalaj" %% "scalaj-http" % "2.4.2"
  )
