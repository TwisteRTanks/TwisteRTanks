use sfml::graphics::*;
use sfml::system::*;

pub struct Tank<'a> {
    pub x: f32,
    pub y: f32,
    pub angle: f32,
    pub sprite: Sprite<'a>,
    pub speed: f32,
}

impl<'a> Tank<'a> {
    pub fn new() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            angle: 0.0,
            sprite: Sprite::new(),
            speed: 10.0,
        }
    }
}