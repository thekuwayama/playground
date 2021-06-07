package com.example

import java.io.File
import java.sql.DriverManager

object Main {
  def main(args: Array[String]): Unit = {
    val host: String             = "localhost"
    val port: Int                = 5432
    val database: String         = "postgres"
    val user: String             = "postgres"
    val password: Option[String] = None

    val url = genJdbcUrl(host, port, database, user)
    Class.forName("org.postgresql.Driver")
    DriverManager.getConnection(url)
  }

  def genJdbcUrl(
    host: String,
    port: Int,
    database: String,
    user: String
  ): String = {
    val currentDir = new File(".").getAbsoluteFile.getParent

    s"jdbc:postgresql://$host:$port/$database" + (Map(
      "user" -> user,
      "ssl" -> true,
      "ssl_max_protocol_version" -> "TLSv1.2",
      "clientcert" -> "verify-full",
      "sslcert" -> s"$currentDir/client.crt",
      "sslkey" -> s"$currentDir/client.key.p8",
      "sslrootcert" -> s"$currentDir/root.crt"
    )).map { case (k, v) => s"$k=$v" }.mkString("?", "&", "")
  }
}
