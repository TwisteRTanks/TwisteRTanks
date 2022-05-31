extern crate sfml;
use sfml::graphics::*;
use sfml::system::Vector2f;

pub enum ButtonType {
    Quit,
    Resume,
}

pub struct Button<'a> {
    pub button_type: ButtonType,
    pub text: Text<'a>,
    pub pos: &'a Vector2f
}

impl<'a> Button<'a> {
    pub fn new(font: &'a Font, button_type: ButtonType, pos: &'a Vector2f) -> Self {
        
        let mut text = Text::new("", font, 11);
        text.set_font(font);
        text.set_fill_color(Color::WHITE);
        
        text.set_character_size(50);

        match button_type {
            ButtonType::Quit => {
                text.set_string("QUIT");
            }
            ButtonType::Resume => {
                text.set_string("RESUME");
            }
        }

        text.set_position(*pos);
        
        Button {
            button_type: button_type,
            text: text,
            pos: pos
        }
    }
}

pub struct Menu<'a> {
    pub buttons: Vec<Button<'a>>,
}

impl<'a> Menu<'a> {
    pub fn draw(&mut self, rw: &mut RenderWindow) {
        println!("{:?}", rw.view().center());
        for button in &mut self.buttons {
            button.text.set_position(rw.view().center() - rw.view().size().x / 2f32);
            rw.draw(&button.text);
        }
    }
}
