use sfml::graphics::*;
use sfml::system::*;

pub struct Tank<'a> {
    pub x: f32,
    pub y: f32,
    pub angle: f32,
    pub sprite: Sprite<'a>,
    pub tsprite: Sprite<'a>, // tsprite is turret sprite
    pub speed: f32,
}

impl<'a> Tank<'a> {
    pub fn new() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            angle: 90.0,
            sprite: Sprite::new(),
            tsprite: Sprite::new(),
            speed: 10.0,
        }
    }
    pub fn update_pos(&mut self){
        self.sprite.set_position((self.x, self.y));
        self.tsprite.set_position((self.x, self.y));
    }
}