#![feature(test)]
extern crate test;

#[bench]
fn sum_bench(b: &mut test::Bencher) {
    b.iter(|| sample_bench::add(1, 2))
}
