use sfml::graphics::*;
use sfml::system::*;
use sfml::SfBox;

use std::time::{Duration, Instant};

use crate::player_tank;
use crate::player_tank::Tank;

pub struct Tile<'a> {
    pub sprite: Sprite<'a>,
}

impl<'a> Tile<'a> {
    pub fn new() -> Self {
        let mut s = Sprite::new();
        Tile { sprite: s }
    }
}

pub struct Map<'a> {
    //tiles: Vec<Tile<'a>>
    pub tile: Tile<'a>,
}

impl<'a> Map<'a> {
    pub fn new() -> Self {
        Map {
            //tiles: Vec::<Tile>::new()
            tile: Tile::new(),
        }
    }

    fn gen_map(&mut self) {
        for x in (0..1000).step_by(180) {
            for y in (0..1000).step_by(180) {
                // not implemented yet
            }
        }
    }

    pub fn render(&mut self, user_tank: &Tank, window: &mut RenderWindow, rs: &RenderStates) {

        for x in (-1000..1000).step_by(64) {
            for y in (0..700).step_by(64) {
                // not implemented yet
                if (x > user_tank.x as i32 - 110 && x < user_tank.x as i32 + 110)
                    && (y > user_tank.y as i32 - 150 && y < user_tank.y as i32 + 90)
                {
                    self.tile.sprite.set_position((x as f32, y as f32));
                    window.draw_sprite(&self.tile.sprite, rs);
                }
            }
        }
        
    }
}
