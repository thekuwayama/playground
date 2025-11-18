#!/usr/bin/env ruby
# frozen_string_literal: true

require 'socket'

port = ARGV[0] || 8888

Socket.tcp_server_loop(port) do |socket, addr|
  p addr

  writer = Ractor.new do
    loop do
      begin
        while (sock_buf = Ractor.receive)
          break if sock_buf.nil?

          sock, buf = sock_buf
          sock.write(buf)
        end
      rescue StandardError => e
        warn e
      ensure
        sock&.close
      end
    end
  end

  loop do
    buf = socket.gets
    writer << [socket, buf]
  end
end
