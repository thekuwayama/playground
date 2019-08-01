fn main() {
    let mut s = String::new();
    std::io::stdin().read_line(&mut s).unwrap();
    let mut iter = s.split_whitespace();

    let r: i32 = iter.next().unwrap().parse().unwrap();

    println!("{}", 3 * r * r);
}
