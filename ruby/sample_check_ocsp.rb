#!/usr/bin/env ruby

require 'openssl'
require 'uri'
require 'net/http'

# get server(=end entity) and issuer certificate from TLS Server(HOSTNAME:PORT)
hostname, port = (ARGV[0] || 'localhost:4433').split(':')
socket = TCPSocket.new(hostname, port)
ssl = OpenSSL::SSL::SSLSocket.new(socket)
ssl.connect
server_cert = ssl.peer_cert
issuer_cert = ssl.peer_cert_chain.last
ssl.close
socket.close

# parse certificate
aia = server_cert.extensions.find { |ex| ex.oid == 'authorityInfoAccess' }
raise 'NO AIA' if aia.nil?

ostr = OpenSSL::ASN1.decode(aia.to_der).value.last
puts ocsp = OpenSSL::ASN1.decode(ostr.value).map(&:value)
                         .find { |des| des.first.value == "OCSP" }[1].value

# create OCSP request
cid = OpenSSL::OCSP::CertificateId.new(
  server_cert,
  issuer_cert,
  OpenSSL::Digest::SHA1.new
)
req = OpenSSL::OCSP::Request.new
req.add_certid(cid)
req.add_nonce

# HTTP POST(OCSP)
ocsp_uri = URI.parse(ocsp)
res = Net::HTTP.start ocsp_uri.host, ocsp_uri.port do |http|
  http.post(
    ocsp_uri.path,
    req.to_der,
    'content-type' => 'application/ocsp-request'
  )
end
puts OpenSSL::OCSP::Response.new(res.body).status_string

# ruby sample_check_ocsp.rb localhost:4433
