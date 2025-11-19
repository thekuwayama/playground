#!/usr/bin/env ruby
# frozen_string_literal: true

require 'socket'

port = ARGV[0] || 8888

class Writer
  attr_reader :port

  def initialize
    @port = Ractor.new do
      loop do
        begin
          sock, s = Ractor.receive

          sock.write(s)
        rescue StandardError => e
          warn e
        end
      end
    end
  end
end

Socket.tcp_server_loop(port) do |socket, addr|
  p addr

  writer = Writer.new
  loop do
    buf = socket.gets
    writer.port << [socket, buf]
  end
end
