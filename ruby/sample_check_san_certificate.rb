#!/usr/bin/env ruby

require 'openssl'

# get certificate from TLS Server(HOSTNAME:PORT)
hostname, port = (ARGV[0] || 'localhost:4433').split(':')
socket = TCPSocket.new(hostname, port)
ssl = OpenSSL::SSL::SSLSocket.new(socket)
ssl.connect
server_cert = ssl.peer_cert
ssl.close
socket.close

# parse certificate
san = server_cert.extensions.find { |ex| ex.oid == 'subjectAltName' }
raise 'NO SAN' if san.nil?

ostr = OpenSSL::ASN1.decode(san.to_der).value.last
pp uris = OpenSSL::ASN1.decode(ostr.value).map(&:value)

# HOSTNAME is included in SANs?
puts uris.map { |uri| uri.gsub('.', '\.').gsub('*', '.*') }
         .any? { |uri|  ARGV[0].match(/#{uri}/) }

# ruby sample_check_san_certificate.rb localhost:4433
