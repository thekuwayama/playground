#!/usr/bin/env ruby

require 'benchmark'

LS8  = 1 << 8 # left shift
LS16 = 1 << 16
LS24 = 1 << 24
LS32 = 1 << 32
LS40 = 1 << 40
LS48 = 1 << 48
LS56 = 1 << 56

def to_uint16_mapjoin(int)
  [
    int / LS8,
    int % LS8
  ].map(&:chr).join
end

def to_uint16_pack(int)
  [int].pack('N1')[2..]
end

def to_uint24_mapjoin(int)
  [
    int / LS16,
    int % LS16 / LS8,
    int % LS8
  ].map(&:chr).join
end

def to_uint24_pack(int)
  [int].pack('N1')[3..]
end

def to_uint32_mapjoin(int)
  [
    int / LS24,
    int % LS24 / LS16,
    int % LS16 / LS8,
    int % LS8
  ].map(&:chr).join
end

def to_uint32_pack(int)
  [int].pack('N1')
end

def to_uint64_mapjoin(int)
  [
    int / LS56,
    int % LS56 / LS48,
    int % LS48 / LS40,
    int % LS40 / LS32,
    int % LS32 / LS24,
    int % LS24 / LS16,
    int % LS16 / LS8,
    int % LS8
  ].map(&:chr).join
end

def to_uint64_pack(int)
  [int >> 32, int].pack('N2')
end

Benchmark.bm 10 do |r|
  r.report 'to_uint16_mapjoin' do
    100000.times do to_uint16_mapjoin(rand 1 << 16) end
  end

  r.report 'to_uint16_pack   ' do
    100000.times do to_uint16_pack(rand 1 << 16) end
  end

  r.report 'to_uint24_mapjoin' do
    100000.times do to_uint24_mapjoin(rand 1 << 24) end
  end

  r.report 'to_uint24_pack   ' do
    100000.times do to_uint24_pack(rand 1 << 24) end
  end

  r.report 'to_uint32_mapjoin' do
    100000.times do to_uint32_mapjoin(rand 1 << 32) end
  end

  r.report 'to_uint32_pack   ' do
    100000.times do to_uint32_pack(rand 1 << 32) end
  end

  r.report 'to_uint64_mapjoin' do
    100000.times do to_uint64_mapjoin(rand 1 << 64) end
  end

  r.report 'to_uint64_pack   ' do
    100000.times do to_uint64_pack(rand 1 << 64) end
  end
end
