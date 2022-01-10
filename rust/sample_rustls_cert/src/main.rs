use std::error::Error;
use std::fs;

use rustls;

fn main() {
    let (cert, key) = read_cert_from_file().unwrap();
    println!("{:?}", cert);
    println!("{:?}", key);
}

fn read_cert_from_file() -> Result<(rustls::Certificate, rustls::PrivateKey), Box<dyn Error>> {
    // Read from certificate and key from directory.
    let (cert, key) = fs::read(&"../../fixtures/server.crt")
        .and_then(|x| Ok((x, fs::read(&"../../fixtures/server.key")?)))?;

    // Parse to certificate chain whereafter taking the first certifcater in this chain.
    let cert = rustls::Certificate(cert);
    let key = rustls::PrivateKey(key);

    Ok((cert, key))
}
