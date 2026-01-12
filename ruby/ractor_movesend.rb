#!/usr/bin/env ruby

r = Ractor.new do
  until (s = Ractor.recv).nil?
    s # do nothing
  end
end

class Message
  def initialize(s)
    @s = s
  end
end

class MessageBuilder
  def initialize
    @h = ['this is message', 'THIS IS MESSAGE'] # Ractor::MovedError
    # FIXME: @h = ['this is message'.freeze, 'THIS IS MESSAGE'.freeze]
  end

  def build(x)
    msg = if x % 3 == 2
            'This is message'
          else
            @h[x % 3]
          end

    Message.new(msg)
  end

  def display
    pp @h
  end
end

builder = MessageBuilder.new

# Ractor#send
msg = builder.build(0)
r.send(msg, move: true)

# access @h
builder.display
