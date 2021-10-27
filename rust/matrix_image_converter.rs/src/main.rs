#[macro_use]
extern crate clap;

use clap::{App, Arg};
use image::DynamicImage;

mod matrix_image_converter;

fn main() {
    let cli = App::new(crate_name!())
        .version(crate_version!())
        .about(crate_description!())
        .arg(
            Arg::with_name("input")
                .help("Input file path")
                .required(true),
        )
        .arg(
            Arg::with_name("output")
                .help("Output file path")
                .required(true),
        );
    let matches = cli.get_matches();
    let input = matches
        .value_of("input")
        .expect("Falid: not specify Input file path");
    let output = matches
        .value_of("output")
        .expect("Falid: not specify Output file path");

    let mut img: DynamicImage = image::open(input).unwrap();

    matrix_image_converter::convert(&mut img);
    img.save(output).expect("Failed: write image");
}
