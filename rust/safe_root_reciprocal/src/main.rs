fn main()  {
    match safe_root_reciprocal(64_f64){
        Some(x) => println!("{}", x),
        None => println!("None"),
    };
}

fn safe_root(x: f64) -> Option<f64> {
    if x >= 0.0 {
        return Some(x.sqrt())
    }

    None
}

fn safe_reciprocal(x: f64) -> Option<f64> {
    if x != 0.0 {
        return Some(1.0 / x)
    }

    None
}

fn safe_root_reciprocal(x: f64) -> Option<f64> {
    safe_reciprocal(x).and_then(|x| safe_root(x))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn testsafe_root_reciprocal() {
        assert_eq!(safe_root_reciprocal(1_f64), Some(1.0));
        assert_eq!(safe_root_reciprocal(4_f64), Some(0.5));
        assert_eq!(safe_root_reciprocal(16_f64), Some(0.25));
        assert_eq!(safe_root_reciprocal(64_f64), Some(0.125));
    }
}
