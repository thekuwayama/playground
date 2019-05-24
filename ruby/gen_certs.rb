#!/usr/bin/env ruby

require 'fileutils'

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
BIN
File.write(EXTFILE, extfile)

`openssl genrsa 4096 > #{CA_KEY}`
`openssl req -new -x509 -days 3650 -sha256 -key #{CA_KEY} -subj "/CN=test-ca" > #{CA_CRT}`

['prime256v1', 'secp384r1', 'secp521r1'].each_with_index do |curve, i|
  server_key = TMP_DIR + "/#{curve}_server.key"
  server_crt = TMP_DIR + "/#{curve}_server.crt"
  `openssl ecparam -name #{curve} -genkey -noout > #{server_key}`
  `openssl req -new -sha256 -key #{server_key} -subj "/CN=localhost" > #{CSR}`
  `openssl x509 -req -in #{CSR} -days 3650 -CA #{CA_CRT} -CAkey #{CA_KEY} -set_serial #{101 + i} -extensions v3_ext -extfile #{EXTFILE} > #{server_crt}`
end

server_key = TMP_DIR + "/rsassaPss_server.key"
server_crt = TMP_DIR + "/rsassaPss_server.crt"
`openssl genrsa 4096 > #{server_key}`
`openssl req -new -sha256 -key #{server_key} -subj "/CN=localhost" > #{CSR}`
`openssl x509 -req -in #{CSR} -days 3650 -CA #{CA_CRT} -CAkey #{CA_KEY} -set_serial 201 -extensions v3_ext -extfile #{EXTFILE} -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:32 > #{server_crt}`

# openssl x509 -in tmp/#{CRT} -noout -text
