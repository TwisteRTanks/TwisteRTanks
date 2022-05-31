use sfml::graphics::*;
use sfml::system::*;
use sfml::SfBox;

use std::slice::Iter;
use std::slice::IterMut;
use std::time::{Duration, Instant};

use crate::player_tank;
use crate::player_tank::Tank;
use crate::resource_manager::TextureIdentifiers;

use rand::Rng;

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
    pub tiles: Vec<(TextureIdentifiers, i32, i32)>,
    pub tile: Tile<'a>,
    pub metal_tile: Tile<'a>,
    pub ice_tile: Tile<'a>,
    pub chess_cage_tile: Tile<'a>,
}

impl<'a> Map<'a> {
    pub fn new() -> Self {
        let mut tiles = Vec::<(TextureIdentifiers, i32, i32)>::new();
        for x in (-1088*2..10000*2).step_by(64) {
            for y in (-1088..10000).step_by(64) {
                let num = rand::thread_rng().gen_range(0..4);

                if num == 0 {
                    tiles.push((TextureIdentifiers::Metal, x, y))
                } else if num == 1 {
                    tiles.push((TextureIdentifiers::Ground, x, y))
                } else if num == 2 {
                    tiles.push((TextureIdentifiers::Ice, x, y))
                } else {
                    tiles.push((TextureIdentifiers::ChessCage, x, y))
                }
            }
        }

        Map {
            tiles: tiles,
            tile: Tile::new(),
            metal_tile: Tile::new(),
            ice_tile: Tile::new(),
            chess_cage_tile: Tile::new(),
        }
    }

    fn norm(&self, n: i32) -> i32 {
        n - (n % 64)
    }

    pub fn render_all(
        &mut self,
        user_tank: &Tank,
        window: &mut RenderWindow,
        rs: &RenderStates,
        v: &View,
    ) {
        self.tile.sprite.set_rotation(0.0);
        let center_of_view = v.center();

        let size_of_view = v.size();

        let left = v.center().x - v.size().x / 2.0;
        let top = v.center().y - v.size().y / 2.0;
        let width = v.size().x;
        let height = v.size().y;

        let visible_area = FloatRect::new(left - 64.0, top - 64.0, width + 64.0, height + 64.0);

        for spr in &self.tiles {
            if visible_area.contains2(spr.1 as f32, spr.2 as f32) {
                match spr.0 {
                    TextureIdentifiers::Metal => {
                        self.metal_tile
                            .sprite
                            .set_position((spr.1 as f32, spr.2 as f32));
                        window.draw_sprite(&self.metal_tile.sprite, rs);
                    }
                    TextureIdentifiers::Ice => {
                        self.ice_tile
                            .sprite
                            .set_position((spr.1 as f32, spr.2 as f32));
                        window.draw_sprite(&self.ice_tile.sprite, rs);
                    }
                    TextureIdentifiers::ChessCage => {
                        self.chess_cage_tile
                            .sprite
                            .set_position((spr.1 as f32, spr.2 as f32));
                        window.draw_sprite(&self.chess_cage_tile.sprite, rs);
                    }
                    TextureIdentifiers::Ground => {
                        self.tile.sprite.set_position((spr.1 as f32, spr.2 as f32));
                        window.draw_sprite(&self.tile.sprite, rs);
                    }
                    _ => {}
                }
            }
        }
    }
}
