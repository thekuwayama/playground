package com.example

import java.io.File
import java.sql.DriverManager

object Main {
  def main(args: Array[String]): Unit = {
    val host: String             = sys.env.getOrElse("HOST", "localhost")
    val port: Int                = sys.env.getOrElse("PORT", "5432").toInt
    val database: String         = sys.env.getOrElse("DBNAME", "postgres")
    val user: String             = sys.env.getOrElse("USER", "postgres")
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
      "user"                     -> user,
      "ssl"                      -> true,
      "ssl_max_protocol_version" -> "TLSv1.2",
      "clientcert"               -> "verify-full",
      "sslcert"                  -> s"$currentDir/client.crt",
      "sslkey"                   -> s"$currentDir/client.key.p8",
      "sslrootcert"              -> s"$currentDir/server-root.crt",
    )).map { case (k, v) => s"$k=$v" }.mkString("?", "&", "")
  }
}
