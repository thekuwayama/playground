require 'openssl'
require 'open-uri'

raise 'pass server_name' if ARGV.length == 0

# using OpenSSL::X509::DEFAULT_CERT_FILE
store = OpenSSL::X509::Store.new
store.set_default_paths

# get certificate from stdin
cert = OpenSSL::X509::Certificate.new(STDIN.read)

san = cert.extensions.select { |ex| ex.oid == 'subjectAltName' }.first&.value
p san.split(',').map { |uri| uri.gsub(/\s*DNS:/, '').gsub('.', '\.').gsub('*', '.*') }
     .any? { |uri|  ARGV[0].match(/#{uri}/) } unless san.nil?

# echo | openssl s_client -connect localhost:443 -showcerts 2>/dev/null | openssl x509 -outform PEM | ruby sample_check_san_certificate.rb localhost
