require 'openssl'
require 'open-uri'

raise 'pass server_name' if ARGV.length == 0

# using OpenSSL::X509::DEFAULT_CERT_FILE
store = OpenSSL::X509::Store.new
store.set_default_paths

# get certificate from stdin
cert = OpenSSL::X509::Certificate.new(STDIN.read)

san = cert.extensions.find { |ex| ex.oid == 'subjectAltName' }
ostr = OpenSSL::ASN1.decode(san.to_der).value.last
p OpenSSL::ASN1.decode(ostr.value).map(&:value)
               .map { |uri| uri.gsub('.', '\.').gsub('*', '.*') }
               .any? { |uri|  ARGV[0].match(/#{uri}/) } unless san.nil?

# echo | openssl s_client -connect localhost:443 -showcerts 2>/dev/null | openssl x509 -outform PEM | ruby sample_check_san_certificate.rb localhost
