#!/usr/bin/env ruby

require 'openssl'

Dir.glob(__dir__ + '/tmp/*_server.crt').each do |fp|
  crt_pem = File.read(fp)
  crt = OpenSSL::X509::Certificate.new(crt_pem)

  spki = OpenSSL::Netscape::SPKI.new
  spki.public_key = crt.public_key
  # puts spki.to_text
  # pp OpenSSL::ASN1.decode(spki.to_der)

  # NOTE:
  #      PublicKeyAndChallenge ::= SEQUENCE {
  #        spki SubjectPublicKeyInfo,
  #        challenge IA5STRING
  #      }
  #
  #      SignedPublicKeyAndChallenge ::= SEQUENCE {
  #        publicKeyAndChallenge PublicKeyAndChallenge,
  #        signatureAlgorithm AlgorithmIdentifier,
  #        signature BIT STRING
  #      }
  #
  # https://docs.ruby-lang.org/en/master/OpenSSL/Netscape/SPKI.html

  # NOTE:
  #      SubjectPublicKeyInfo  ::=  SEQUENCE  {
  #        algorithm         AlgorithmIdentifier,
  #        subjectPublicKey  BIT STRING
  #      }
  #
  #      AlgorithmIdentifier  ::=  SEQUENCE  {
  #        algorithm   OBJECT IDENTIFIER,
  #        parameters  ANY DEFINED BY algorithm OPTIONAL
  #      }
  #
  # https://tools.ietf.org/html/rfc5480#section-2
  #
  # For example, rsaEncryption
  #
  #      rsaEncryption OBJECT IDENTIFIER ::= {
  #        iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-1(1) 1 }
  #
  #      RSAPublicKey ::= SEQUENCE {
  #        modulus         INTEGER, -- n
  #        publicExponent  INTEGER  -- e
  #      }
  #
  # https://tools.ietf.org/html/rfc5480#appendix-A

  puts OpenSSL::ASN1.decode(spki.to_der)  # SignedPublicKeyAndChallenge
                    .value.first          # SignedPublicKeyAndChallenge[:publicKeyAndChallenge]
                    .value.first          # PublicKeyAndChallenge[:spki]
                    .value.first          # SubjectPublicKeyInfo[:algorithm]
                    .value.first          # AlgorithmIdentifier[:algorithm]
                    .value                # rsaEncryption
end
