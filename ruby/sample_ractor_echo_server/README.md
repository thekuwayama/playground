## Usage

```bash
$ bundle install
```

```bash
$ bundle exec ruby server.rb
<internal:ractor>:267: warning: Ractor is experimental, and the behavior may change in future versions of Ruby! Also there are many implementation issues.
#<Addrinfo: 127.0.0.1:60455 TCP>
```

```bash
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
