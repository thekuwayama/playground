#!/usr/bin/env ruby

require 'open3'

scmd = 'openssl s_server -cert tmp/server.crt -key tmp/server.key'
spid = spawn(scmd, in: '/dev/null')

ccmd = 'openssl s_client -connect localhost:4433 < /dev/null'
o, e, s = Open3.capture3(ccmd)
print o
print e

Process.detach(spid)
puts 'ok' if s.exited? && s.exitstatus.zero?
