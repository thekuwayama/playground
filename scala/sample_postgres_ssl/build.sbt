import Dependencies._

ThisBuild / scalaVersion     := "2.12.8"
ThisBuild / version          := "0.1.0-SNAPSHOT"
ThisBuild / organization     := "com.example"
ThisBuild / organizationName := "example"

val postgresqlJDBCVersion = "42.2.5"

lazy val root = (project in file("."))
  .settings(
    name := "sample_psql_ssl",
    libraryDependencies ++= Seq(
      scalaTest % Test,

      "org.postgresql" % "postgresql" % postgresqlJDBCVersion
    )
  )
