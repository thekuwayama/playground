require 'openssl'
require 'securerandom'

data = SecureRandom.random_bytes(657)
nonce = 'nonce nonce ' # iv must be 12 bytes
auth_data = 'authentication data'

# encrypt
cipher = OpenSSL::Cipher::AES.new(128, :GCM).encrypt
write_key = cipher.random_key
cipher.iv = nonce
cipher.auth_data = auth_data

encrypted = cipher.update(data) + cipher.final
tag = cipher.auth_tag

# decrypt
decipher = OpenSSL::Cipher::AES.new(128, :GCM).decrypt
decipher.key = write_key
decipher.iv = nonce
decipher.auth_tag = tag
decipher.auth_data = auth_data

decrypted = decipher.update(encrypted) + decipher.final

# check
puts 'ok' if data == decrypted
