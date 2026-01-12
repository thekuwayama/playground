#!/usr/bin/env ruby

r = Ractor.new do
  until (msg = Ractor.recv).nil?
    puts "in Ractor: #{msg.s.object_id}"
  end
end

class Message
  attr_reader :s

  def initialize(s)
    @s = s
  end
end

class MessageBuilder
  def initialize
    # @h = ['this is message', 'THIS IS MESSAGE'] # Ractor::MovedError
    @h = ['this is message'.freeze, 'THIS IS MESSAGE'.freeze]
  end

  def build(x)
    Message.new(@h[x % 2])
  end

  def display(prefix)
    puts "#{prefix}: #{@h.map(&:object_id)}"
  end
end

builder = MessageBuilder.new

# Ractor#send
msg = builder.build(0)
r.send(msg, move: true)

# Ractor#send
msg = builder.build(1)
r.send(msg, move: true)

# access @h
builder.display('main Ractor')
