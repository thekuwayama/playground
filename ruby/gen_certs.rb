#!/usr/bin/env ruby

require 'fileutils'
require 'openssl'

TMP_DIR = __dir__ + '/tmp'
CA_CRT = TMP_DIR + '/rsa_ca.crt'
CA_KEY = TMP_DIR + '/rsa_ca.key'
EXTFILE = TMP_DIR + '/extfile'
CSR = TMP_DIR + '/csr'

FileUtils.mkdir_p(TMP_DIR)

extfile = <<BIN
[ v3_ext ]
basicConstraints=CA:FALSE
keyUsage=digitalSignature, keyCertSign
subjectAltName=DNS:localhost
authorityInfoAccess=OCSP;URI:http://localhost/ocsp,caIssuers;URI:http://localhost/caIssuers
BIN
File.write(EXTFILE, extfile)

`openssl genrsa 2048 > #{CA_KEY}`
`openssl req -new -x509 -days 3650 -sha256 -key #{CA_KEY} -subj "/CN=test-ca" > #{CA_CRT}`

['prime256v1', 'secp384r1', 'secp521r1'].each do |curve|
  server_key = TMP_DIR + "/#{curve}_server.key"
  server_crt = TMP_DIR + "/#{curve}_server.crt"
  `openssl ecparam -name #{curve} -genkey -noout > #{server_key}`
  `openssl req -new -sha256 -key #{server_key} -subj "/CN=localhost" > #{CSR}`
  `openssl x509 -req -in #{CSR} -days 3650 -CA #{CA_CRT} -CAkey #{CA_KEY} -extensions v3_ext -extfile #{EXTFILE} -set_serial #{OpenSSL::BN.rand(64).to_i} > #{server_crt}`
end

[256, 384, 512].each do |hs|
  server_key = TMP_DIR + "/rsassaPss_sha#{hs}_server.key"
  server_crt = TMP_DIR + "/rsassaPss_sha#{hs}_server.crt"
  `openssl genrsa 2048 > #{server_key}`
  `openssl req -new -sha#{hs} -key #{server_key} -subj "/CN=localhost" > #{CSR}`
  `openssl x509 -req -in #{CSR} -days 3650 -sha#{hs} -CA #{CA_CRT} -CAkey #{CA_KEY} -extensions v3_ext -extfile #{EXTFILE} -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:#{hs / 8} -set_serial #{OpenSSL::BN.rand(64).to_i} > #{server_crt}`
end

extfile = <<BIN
[ v3_ext ]
basicConstraints=CA:FALSE
extendedKeyUsage=OCSPSigning
subjectAltName=DNS:test-ocsp
BIN
File.write(EXTFILE, extfile)

ocsp_key = TMP_DIR + '/rsa_rsa_ocsp.key'
ocsp_crt = TMP_DIR + '/rsa_rsa_ocsp.crt'
`openssl genrsa 2048 > #{ocsp_key}`
`openssl req -new -sha256 -key #{ocsp_key} -subj "/CN=test-ocsp" > #{CSR}`
`openssl x509 -req -in #{CSR} -days 3650 -sha256 -CA #{CA_CRT} -CAkey #{CA_KEY} -extensions v3_ext -extfile #{EXTFILE} -set_serial #{OpenSSL::BN.rand(64).to_i} > #{ocsp_crt}`

# openssl x509 -in tmp/$CRT -noout -text
