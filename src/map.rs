use sfml::graphics::*;
use sfml::system::*;
use sfml::SfBox;


use crate::player_tank::Tank;

pub struct Tile<'a> {
    pub sprite: Sprite<'a>
}

impl<'a> Tile<'a>{
    pub fn new() -> Self{
        let mut s = Sprite::new();
        Tile {
            sprite: s
        }
    }
}

pub struct Map<'a>{
    tiles: Vec<Tile<'a>>

}

impl<'a> Map<'a>{
    fn new() -> Self{
        Map {
            tiles: Vec::<Tile>::new()
        }
    }
    
    fn gen_map(&mut self){
        for x in (0..1000).step_by(60){
            for y in (0..1000).step_by(60){
                // not implemented yet
            }
        }
    }
    
    fn render(&mut self, user_tank: &Tank, window: &mut RenderWindow, rs: &RenderStates){
        window.draw_sprite(&self.sprite, rs)
        //let groud_tex = Texture::from_file("resources/ground.png").unwrap();

        
    }
}