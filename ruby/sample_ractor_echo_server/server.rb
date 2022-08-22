#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'socket'

port = ARGV[0] || 8888

queue = Ractor.new do
  loop do
    Ractor.yield(Ractor.recv, move: true)
  end
end

Etc.nprocessors.times do
  Ractor.new(queue) do |q|
    loop do
      s = q.take
      begin
        while (buf = s.gets)
          s.write buf
        end
      rescue StandardError => e
        warn e
      ensure
        s&.close
      end
    end
  end
end

Socket.tcp_server_loop(port) do |socket, addr|
  p addr
  queue.send(socket, move: true)
end
