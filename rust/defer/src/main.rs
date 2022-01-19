#[derive(Default, Debug)]
struct Deferize;

impl Drop for Deferize {
    fn drop(&mut self) {
        println!("exit");
    }
}

fn main() {
    let _defer = Deferize::default();
    println!("start");
}
