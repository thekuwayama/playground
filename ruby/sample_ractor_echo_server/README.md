```sh-session
$ bundle install
```

```sh-session
$ bundle exec ruby server.rb
<internal:ractor>:267: warning: Ractor is experimental, and the behavior may change in future versions of Ruby! Also there are many implementation issues.
#<Addrinfo: 127.0.0.1:60455 TCP>
```

```sh-session
$ telnet 127.0.0.1 8888
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
hoge
hoge
piyo
piyo
^]
telnet> Connection closed.
```
