fn fibonacci(n: u32) -> u32 {
    if dbg!(n <= 1) {
        dbg!(1)
    } else {
        dbg!(fibonacci(n - 2) + fibonacci(n - 1))
    }
}

fn main() {
    dbg!(fibonacci(10));
}
