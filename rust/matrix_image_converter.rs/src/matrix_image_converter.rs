use image::DynamicImage;
use image::GenericImage;
use image::GenericImageView;
use image::Rgba;

pub fn convert(img: &mut DynamicImage) {
    let (w, h) = img.dimensions();

    for y in 0..h {
        for x in 0..w {
            let pixel = img.get_pixel(x, y);
            let red: f64 = pixel[0].into();
            let green: f64 = pixel[1].into();
            let blue: f64 = pixel[2].into();
            let alpha: u8 = pixel[3];

            let pixel: Rgba<u8> = Rgba([
                (red * 5.0 / 6.0) as u8,
                (green * 8.0 / 7.0) as u8,
                (blue * 5.0 / 6.0) as u8,
                alpha,
            ]);
            img.put_pixel(x, y, pixel);
        }
    }

    ()
}
