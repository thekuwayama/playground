fn main() {
    let a = |x: u8| -> u8 { x + 2};
    let b = |x: u8| -> u8 { x * 2};

    println!("((0 * 2) + 2) = {}", g_after_f(a, b)(0));
    println!("((0 + 2) * 2) = {}", g_after_f(b, a)(0));
}

fn g_after_f(g: fn(u8) -> u8, f: fn(u8) -> u8) -> impl Fn(u8) -> u8 { return  move |x: u8| { g(f(x)) } }
