fn main() {
    let mut s = String::new();
    std::io::stdin().read_line(&mut s).unwrap();
    let mut iter = s.split_whitespace();

    let n: i32 = iter.next().unwrap().parse().unwrap();
    let d: i32 = iter.next().unwrap().parse().unwrap();

    let res;
    if n % (d * 2 + 1) != 0 {
        res = n / (d * 2 + 1) + 1;
    } else {
        res = n / (d * 2 + 1);
    }
    println!("{}", res);
}
