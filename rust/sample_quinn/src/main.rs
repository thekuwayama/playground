use std::{error::Error, net::SocketAddr, sync::Arc};

use futures_util::StreamExt;
use quinn::{ClientConfig, Endpoint, Incoming, ServerConfig};
use rcgen;
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // server and client are running on the same thread asynchronously
    let addr = "127.0.0.1:5000".parse().unwrap();
    tokio::spawn(run_server(addr));
    run_client(addr).await.unwrap();
    Ok(())
}

/// Runs a QUIC server bound to given address.
async fn run_server(addr: SocketAddr) {
    let (mut incoming, _server_cert) = make_server_endpoint(addr).unwrap();
    // accept a single connection
    let incoming_conn = incoming.next().await.unwrap();
    let new_conn = incoming_conn.await.unwrap();
    println!(
        "[server] connection accepted: addr={}",
        new_conn.connection.remote_address()
    );
}

async fn run_client(server_addr: SocketAddr) -> Result<(), Box<dyn Error>> {
    let client_cfg = configure_client();
    let mut endpoint = Endpoint::client("127.0.0.1:0".parse().unwrap())?;
    endpoint.set_default_client_config(client_cfg);

    // connect to server
    let quinn::NewConnection { connection, .. } = endpoint
        .connect(server_addr, "localhost")
        .unwrap()
        .await
        .unwrap();
    println!("[client] connected: addr={}", connection.remote_address());
    // Dropping handles allows the corresponding objects to automatically shut down
    drop(connection);
    // Make sure the server has a chance to clean up
    endpoint.wait_idle().await;

    Ok(())
}

/// Dummy certificate verifier that treats any certificate as valid.
/// NOTE, such verification is vulnerable to MITM attacks, but convenient for testing.
struct SkipServerVerification;

impl SkipServerVerification {
    fn new() -> Arc<Self> {
        Arc::new(Self)
    }
}

impl rustls::client::ServerCertVerifier for SkipServerVerification {
    fn verify_server_cert(
        &self,
        _end_entity: &rustls::Certificate,
        _intermediates: &[rustls::Certificate],
        _server_name: &rustls::ServerName,
        _scts: &mut dyn Iterator<Item = &[u8]>,
        _ocsp_response: &[u8],
        _now: std::time::SystemTime,
    ) -> Result<rustls::client::ServerCertVerified, rustls::Error> {
        Ok(rustls::client::ServerCertVerified::assertion())
    }
}

fn configure_client() -> ClientConfig {
    let crypto = rustls::ClientConfig::builder()
        .with_safe_defaults()
        .with_custom_certificate_verifier(SkipServerVerification::new())
        .with_no_client_auth();

    ClientConfig::new(Arc::new(crypto))
}

fn make_server_endpoint(bind_addr: SocketAddr) -> Result<(Incoming, Vec<u8>), Box<dyn Error>> {
    let (server_config, server_cert) = configure_server()?;
    let (_endpoint, incoming) = Endpoint::server(server_config, bind_addr)?;
    Ok((incoming, server_cert))
}

fn configure_server() -> Result<(ServerConfig, Vec<u8>), Box<dyn Error>> {
    let (cert, priv_key) = generate_self_signed_cert()?;
    let cert_der = cert.as_ref().to_vec();
    let cert_chain = vec![cert];

    let mut server_config = ServerConfig::with_single_cert(cert_chain, priv_key)?;
    Arc::get_mut(&mut server_config.transport)
        .unwrap()
        .max_concurrent_uni_streams(0_u8.into());

    Ok((server_config, cert_der))
}

fn generate_self_signed_cert() -> Result<(rustls::Certificate, rustls::PrivateKey), Box<dyn Error>>
{
    let cert = rcgen::generate_simple_self_signed(vec!["localhost".to_string()]).unwrap();
    let key = rustls::PrivateKey(cert.serialize_private_key_der());
    Ok((rustls::Certificate(cert.serialize_der().unwrap()), key))
}
