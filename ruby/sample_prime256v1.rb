require 'openssl'

# testcase
client_private_key = <<BIN.split.map(&:hex).map(&:chr).join
  ab 54 73 46 7e 19 34 6c     eb 0a 04 14 e4 1d a2 1d
  4d 24 45 bc 30 25 af e9     7c 4e 8d c8 d5 13 da 39
BIN
# p client_private_key
ec = OpenSSL::PKey::EC.new('prime256v1')
ec.private_key = OpenSSL::BN.new(client_private_key, 2)

server_public_key = <<BIN.split.map(&:hex).map(&:chr).join
  04 58 3e 05 4b 7a 66 67     2a e0 20 ad 9d 26 86 fc
  c8 5b 5a d4 1a 13 4a 0f     03 ee 72 b8 93 05 2b d8
  5b 4c 8d e6 77 6f 5b 04     ac 07 d8 35 40 ea b3 e3
  d9 c5 47 bc 65 28 c4 31     7d 29 46 86 09 3a 6c ad
  7d
BIN
# p server_public_key
pub_key  = OpenSSL::PKey::EC::Point.new(
  OpenSSL::PKey::EC::Group.new('prime256v1'),
  OpenSSL::BN.new(server_public_key, 2)
)

shared_secret = ec.dh_compute_key(pub_key)
# p shared_secret
puts 'ok' if shared_secret == <<BIN.split.map(&:hex).map(&:chr).join
  c1 42 ce 13 ca 11 b5 c2     23 36 52 e6 3a d3 d9 78
  44 f1 62 1f bf b9 de 69     d5 47 dc 8f ed ea be b4
BIN

# generate key
client_ec = OpenSSL::PKey::EC.new('prime256v1')
client_ec.generate_key!
client_key_exchange = client_ec.public_key.to_octet_string(:uncompressed)

server_ec = OpenSSL::PKey::EC.new('prime256v1')
server_ec.generate_key!
server_key_exchange = server_ec.public_key.to_octet_string(:uncompressed)

client_shared_key = client_ec.dh_compute_key(
  OpenSSL::PKey::EC::Point.new(
    OpenSSL::PKey::EC::Group.new('prime256v1'),
    server_key_exchange
  )
)
server_shared_key = server_ec.dh_compute_key(
  OpenSSL::PKey::EC::Point.new(
    OpenSSL::PKey::EC::Group.new('prime256v1'),
    client_key_exchange
  )
)

puts 'ok' if client_shared_key == server_shared_key
