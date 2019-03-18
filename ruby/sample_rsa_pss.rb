require 'openssl'

content = <<BIN
2020202020202020202020202020202020202020202020202020202020202020
2020202020202020202020202020202020202020202020202020202020202020
544c5320312e332c207365727665722043657274696669636174655665726966
79
00
0101010101010101010101010101010101010101010101010101010101010101
BIN

content = [content.delete("\n")].pack('h*')
private_key = OpenSSL::PKey::RSA.new(2048)
signature = private_key.sign_pss('SHA256',
                                 content,
                                 salt_length: :max,
                                 mgf1_hash: 'SHA256')
public_key = private_key.public_key

puts public_key.verify_pss('SHA256',
                           signature,
                           content,
                           salt_length: :auto,
                           mgf1_hash: 'SHA256')
