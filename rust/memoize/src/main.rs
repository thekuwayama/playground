use std::collections::HashMap;
use std::{thread, time};

fn main() {
    let mut memo = Memo::new(plus1);
    println!("{}", memo.memoize(1));
    println!("{}", memo.memoize(1));
}

struct Memo {
    f: fn(u8) -> u8,
    m: HashMap<u8, u8>,
}

impl Memo {
    pub fn new(f: fn(u8) -> u8) -> Self {
        Memo{
            f: f,
            m: HashMap::new(),
        }
    }

    pub fn memoize(&mut self, arg: u8) -> u8 {
        match self.m.get(&arg) {
            Some(res) => *res,
            None => {
                let res = (self.f)(arg);
                self.m.insert(arg, res);
                res
            }
        }
    }
}

fn plus1(x: u8) -> u8 {
    thread::sleep(time::Duration::from_secs(1));
    x + 1
}
