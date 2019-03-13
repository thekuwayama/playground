require 'openssl'

def check_and_puts(l, r)
  boolean = (l == r)
  if boolean
    puts 'ok'
    return
  end
  puts 'ng'
end

#    HKDF-Extract(salt, IKM) -> PRK
#    HKDF-Expand(PRK, info, L) -> OKM
def hkdf_extract(digest:, salt:, ikm:)
  OpenSSL::HMAC.digest(digest, salt, ikm)
end

## HKDF-Extract testcase 1
salt = "\x00" * 32 # length of 'SHA256' hash
ikm = "\x00" * 32 # length of 'SHA256' hash
secret = <<BIN.split.map(&:hex).map(&:chr).join
  33 ad 0a 1c 60 7e c0 3b     09 e6 cd 98 93 68 0c e2
  10 ad f3 00 aa 1f 26 60     e1 b2 2e 10 f1 70 f9 2a
BIN
check_and_puts(hkdf_extract(digest: 'SHA256', salt: salt, ikm: ikm),
               secret)

## HKDF-Extract testcase 2
salt = <<BIN.split.map(&:hex).map(&:chr).join
  5f 17 90 bb d8 2c 5e 7d     37 6e d2 e1 e5 2f 8e 60
  38 c9 34 6d b6 1b 43 be     9a 52 f7 7e f3 99 8e 80
BIN
ikm = <<BIN.split.map(&:hex).map(&:chr).join
  f4 41 94 75 6f f9 ec 9d     25 18 06 35 d6 6e a6 82
  4c 6a b3 bf 17 99 77 be     37 f7 23 57 0e 7c cb 2e
BIN
secret = <<BIN.split.map(&:hex).map(&:chr).join
  00 5c b1 12 fd 8e b4 cc     c6 23 bb 88 a0 7c 64 b3
  ed e1 60 53 63 fc 7d 0d     f8 c7 ce 4f f0 fb 4a e6
BIN
check_and_puts(hkdf_extract(digest: 'SHA256', salt: salt, ikm: ikm),
               secret)

# HKDF-Expand-Label
def hkdf_expand_label(secret:, label:, context:, length:, digest:)
  binary = [length / (1 << 8), length % (1 << 8)].map(&:chr).join
  label = 'tls13 ' + label
  binary += label.length.chr
  binary += label
  binary += context.length.chr
  binary += context
  # puts binary.bytes.map { |x| format("%02x", x) }.join(' ') # info
  hkdf_expand(secret: secret, info: binary, length: length, digest: digest)
end

#        HKDF-Expand-Label(Secret, Label, Context, Length) =
#             HKDF-Expand(Secret, HkdfLabel, Length)
def hkdf_expand(secret:, info:, length:, digest:)
  okm = ''
  t = ''
  (1..length).each do |i|
    t = OpenSSL::HMAC.digest(digest, secret, t + info + i.chr)
    okm << t
  end
  okm[0...length]
end

## HFKD-Expand-Label testcase 1
secret = <<BIN.split.map(&:hex).map(&:chr).join
  b6 7b 7d 69 0c c1 6c 4e     75 e5 42 13 cb 2d 37 b4
  e9 c9 12 bc de d9 10 5d     42 be fd 59 d3 91 ad 38
BIN
label = 'finished'
context = ''
length = 32
digest = 'SHA256'
prk = <<BIN.split.map(&:hex).map(&:chr).join
  00 8d 3b 66 f8 16 ea 55     9f 96 b5 37 e8 85 c3 1f
  c0 68 bf 49 2c 65 2f 01     f2 88 a1 d8 cd c1 9f c8
BIN
check_and_puts(hkdf_expand_label(secret: secret, label: label, context: context, length: length, digest: digest),
               prk)

## HFKD-Expand-Label testcase 2
secret = <<BIN.split.map(&:hex).map(&:chr).join
  7d f2 35 f2 03 1d 2a 05     12 87 d0 2b 02 41 b0 bf
  da f8 6c c8 56 23 1f 2d     5a ba 46 c4 34 ec 19 6c
BIN
label = 'resumption'
context = "\x00\x00"
length = 32
digest = 'SHA256'
prk = <<BIN.split.map(&:hex).map(&:chr).join
  4e cd 0e b6 ec 3b 4d 87     f5 d6 02 8f 92 2c a4 c5
  85 1a 27 7f d4 13 11 c9     e6 2d 2c 94 92 e1 c4 f3
BIN
check_and_puts(hkdf_expand_label(secret: secret, label: label, context: context, length: length, digest: digest),
               prk)

#        Derive-Secret(Secret, Label, Messages) =
#            HKDF-Expand-Label(Secret, Label,
#                              Transcript-Hash(Messages), Hash.length)
def derive_secret(secret:, label:, messages:, length:, digest:)
  transcript_hash = OpenSSL::Digest.digest(digest, messages)
  # puts transcript_hash.bytes.map { |x| format("%02x", x) }.join(' ') # hash
  hkdf_expand_label(secret: secret, label: label, context: transcript_hash, length: length, digest: digest)
end

## Derive-Secret testcase 1
secret = <<BIN.split.map(&:hex).map(&:chr).join
  9b 21 88 e9 b2 fc 6d 64     d7 1d c3 29 90 0e 20 bb
  41 91 50 00 f6 78 aa 83     9c bb 79 7c b7 d8 33 2c
BIN
label = 'derived'
messages = <<BIN.split.map(&:hex).map(&:chr).join
BIN
length = 32
digest = 'SHA256'
prk = <<BIN.split.map(&:hex).map(&:chr).join
  5f 17 90 bb d8 2c 5e 7d     37 6e d2 e1 e5 2f 8e 60
  38 c9 34 6d b6 1b 43 be     9a 52 f7 7e f3 99 8e 80
BIN
check_and_puts(derive_secret(secret: secret, label: label, messages: messages, length: length, digest: digest),
               prk)

## Derive-Secret testcase 1
secret = <<BIN.split.map(&:hex).map(&:chr).join
  1d c8 26 e9 36 06 aa 6f     dc 0a ad c1 2f 74 1b 01
  04 6a a6 b9 9f 69 1e d2     21 a9 f0 ca 04 3f be ac
BIN
label = 's hs traffic'
messages = <<BIN.split.map(&:hex).map(&:chr).join
  01 00 00 c0 03 03 cb 34     ec b1 e7 81 63 ba 1c 38
  c6 da cb 19 6a 6d ff a2     1a 8d 99 12 ec 18 a2 ef
  62 83 02 4d ec e7 00 00     06 13 01 13 03 13 02 01
  00 00 91 00 00 00 0b 00     09 00 00 06 73 65 72 76
  65 72 ff 01 00 01 00 00     0a 00 14 00 12 00 1d 00
  17 00 18 00 19 01 00 01     01 01 02 01 03 01 04 00
  23 00 00 00 33 00 26 00     24 00 1d 00 20 99 38 1d
  e5 60 e4 bd 43 d2 3d 8e     43 5a 7d ba fe b3 c0 6e
  51 c1 3c ae 4d 54 13 69     1e 52 9a af 2c 00 2b 00
  03 02 03 04 00 0d 00 20     00 1e 04 03 05 03 06 03
  02 03 08 04 08 05 08 06     04 01 05 01 06 01 02 01
  04 02 05 02 06 02 02 02     00 2d 00 02 01 01 00 1c
  00 02 40 01

  02 00 00 56 03 03 a6 af     06 a4 12 18 60 dc 5e 6e
  60 24 9c d3 4c 95 93 0c     8a c5 cb 14 34 da c1 55
  77 2e d3 e2 69 28 00 13     01 00 00 2e 00 33 00 24
  00 1d 00 20 c9 82 88 76     11 20 95 fe 66 76 2b db
  f7 c6 72 e1 56 d6 cc 25     3b 83 3d f1 dd 69 b1 b0
  4e 75 1f 0f 00 2b 00 02     03 04
BIN
length = 32
digest = 'SHA256'
prk = <<BIN.split.map(&:hex).map(&:chr).join
  b6 7b 7d 69 0c c1 6c 4e     75 e5 42 13 cb 2d 37 b4
  e9 c9 12 bc de d9 10 5d     42 be fd 59 d3 91 ad 38
BIN
check_and_puts(derive_secret(secret: secret, label: label, messages: messages, length: length, digest: digest),
               prk)

# implements derive_secret with openssl
def derive_secret_with_openssl(salt:, ikm:, label:, messages:, length:, digest:)
  secret = hkdf_extract(digest: digest, salt: salt, ikm: ikm)
  # puts secret.bytes.map { |x| format("%02x", x) }.join(' ')
  transcript_hash = OpenSSL::Digest.digest(digest, messages)
  hkdf_expand_label_with_openssl(salt: salt, ikm: ikm, label: label, context: transcript_hash, length: length, digest: digest)
end

def hkdf_expand_label_with_openssl(salt:, ikm:, label:, context:, length:, digest:)
  binary = [length / (1 << 8), length % (1 << 8)].map(&:chr).join
  label = 'tls13 ' + label
  binary += label.length.chr
  binary += label
  binary += context.length.chr
  binary += context

  hash = OpenSSL::Digest.new(digest)
  OpenSSL::KDF.hkdf(ikm, salt: salt, info: binary, length: length, hash: hash)
end

## Derive-Secret testcase 1
salt = <<BIN.split.map(&:hex).map(&:chr).join
  6f 26 15 a1 08 c7 02 c5     67 8f 54 fc 9d ba b6 97
  16 c0 76 18 9c 48 25 0c     eb ea c3 57 6c 36 11 ba
BIN
ikm = <<BIN.split.map(&:hex).map(&:chr).join
  8b d4 05 4f b5 5b 9d 63     fd fb ac f9 f0 4b 9f 0d
  35 e6 d6 3f 53 75 63 ef     d4 62 72 90 0f 89 49 2d
BIN
label = 's hs traffic'
messages = <<BIN.split.map(&:hex).map(&:chr).join
  01 00 00 c0 03 03 cb 34     ec b1 e7 81 63 ba 1c 38
  c6 da cb 19 6a 6d ff a2     1a 8d 99 12 ec 18 a2 ef
  62 83 02 4d ec e7 00 00     06 13 01 13 03 13 02 01
  00 00 91 00 00 00 0b 00     09 00 00 06 73 65 72 76
  65 72 ff 01 00 01 00 00     0a 00 14 00 12 00 1d 00
  17 00 18 00 19 01 00 01     01 01 02 01 03 01 04 00
  23 00 00 00 33 00 26 00     24 00 1d 00 20 99 38 1d
  e5 60 e4 bd 43 d2 3d 8e     43 5a 7d ba fe b3 c0 6e
  51 c1 3c ae 4d 54 13 69     1e 52 9a af 2c 00 2b 00
  03 02 03 04 00 0d 00 20     00 1e 04 03 05 03 06 03
  02 03 08 04 08 05 08 06     04 01 05 01 06 01 02 01
  04 02 05 02 06 02 02 02     00 2d 00 02 01 01 00 1c
  00 02 40 01

  02 00 00 56 03 03 a6 af     06 a4 12 18 60 dc 5e 6e
  60 24 9c d3 4c 95 93 0c     8a c5 cb 14 34 da c1 55
  77 2e d3 e2 69 28 00 13     01 00 00 2e 00 33 00 24
  00 1d 00 20 c9 82 88 76     11 20 95 fe 66 76 2b db
  f7 c6 72 e1 56 d6 cc 25     3b 83 3d f1 dd 69 b1 b0
  4e 75 1f 0f 00 2b 00 02     03 04
BIN
length = 32
digest = 'SHA256'
prk = <<BIN.split.map(&:hex).map(&:chr).join
  b6 7b 7d 69 0c c1 6c 4e     75 e5 42 13 cb 2d 37 b4
  e9 c9 12 bc de d9 10 5d     42 be fd 59 d3 91 ad 38
BIN
check_and_puts(derive_secret_with_openssl(salt: salt, ikm: ikm, label: label, messages: messages, length: length, digest: digest),
               prk)

# $ brew install openssl@1.1
# $ ln -s /usr/local/opt/openssl\@1.1 /usr/local/opt/openssl
# $ CONFIGURE_OPTS="--with-openssl-dir=/usr/local/opt/openssl" rbenv install 2.6.0
# $ ruby -ropenssl -e "p OpenSSL::OPENSSL_VERSION" # =>"OpenSSL 1.1.?? dd bb YYYY"
