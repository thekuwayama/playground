#![feature(addr_parse_ascii)]

use std::net::Ipv6Addr;

fn main() {
    println!("{}", Ipv6Addr::parse_ascii(b"2001:db8:0:0:1:0:0:1").unwrap());
    println!("{}", Ipv6Addr::parse_ascii(b"2001:0db8:0:0:1:0:0:1").unwrap());
    println!("{}", Ipv6Addr::parse_ascii(b"2001:db8::1:0:0:1").unwrap());
    println!("{}", Ipv6Addr::parse_ascii(b"2001:db8::0:1:0:0:1").unwrap());
    println!("{}", Ipv6Addr::parse_ascii(b"2001:0db8::1:0:0:1").unwrap());
    println!("{}", Ipv6Addr::parse_ascii(b"2001:db8:0:0:1::1").unwrap());
    println!("{}", Ipv6Addr::parse_ascii(b"2001:db8:0000:0:1::1").unwrap());
}
