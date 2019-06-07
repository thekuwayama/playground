#!/usr/bin/env ruby

require 'openssl'

key_pem = File.read(__dir__ + '/tmp/server.key')
crt_pem = File.read(__dir__ + '/tmp/server.crt')
key = OpenSSL::PKey::RSA.new(key_pem)
crt = OpenSSL::X509::Certificate.new(crt_pem)

# NOTE:
#       RSAPrivateKey ::= SEQUENCE {
#           version           Version,
#           modulus           INTEGER,  -- n
#           publicExponent    INTEGER,  -- e
#           privateExponent   INTEGER,  -- d
#           prime1            INTEGER,  -- p
#           prime2            INTEGER,  -- q
#           exponent1         INTEGER,  -- d mod (p-1)
#           exponent2         INTEGER,  -- d mod (q-1)
#           coefficient       INTEGER,  -- (inverse of q) mod p
#           otherPrimeInfos   OtherPrimeInfos OPTIONAL
#       }
# https://tools.ietf.org/html/rfc3447#appendix-A.1.2
asn1 = OpenSSL::ASN1::Sequence(
  [
    OpenSSL::ASN1::Integer(0),
    OpenSSL::ASN1::Integer(key.n),
    OpenSSL::ASN1::Integer(key.e),
    OpenSSL::ASN1::Integer(key.d),
    OpenSSL::ASN1::Integer(key.p),
    OpenSSL::ASN1::Integer(key.q),
    OpenSSL::ASN1::Integer(key.dmp1),
    OpenSSL::ASN1::Integer(key.dmq1),
    OpenSSL::ASN1::Integer(key.iqmp)
  ]
)
puts 'private key: ok' if asn1.to_der == key.to_der
# puts key.to_text

# NOTE:
#       RSAPublicKey ::= SEQUENCE {
#           modulus           INTEGER,  -- n
#           publicExponent    INTEGER   -- e
#       }
# https://tools.ietf.org/html/rfc3447#appendix-A.1.1
asn1 = OpenSSL::ASN1::Sequence(
  [
    OpenSSL::ASN1::Integer(crt.public_key.n),
    OpenSSL::ASN1::Integer(crt.public_key.e)
  ]
)
puts 'public key: ok' if OpenSSL::PKey::RSA.new(asn1).to_der == crt.public_key.to_der
# puts crt.public_key.to_der

puts 'key.public_key is equal to crt.public_key' if key.public_key.to_der == crt.public_key.to_der
