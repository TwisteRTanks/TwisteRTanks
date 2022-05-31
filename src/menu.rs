extern crate sfml;
use sfml::graphics::*;
use sfml::system::Vector2f;

pub enum ButtonType {
    Quit,
    Resume,
    Play,
    About
}

pub struct Button<'a> {
    pub button_type: ButtonType,
    pub text: Text<'a>,
    pub x: f32,
    pub y: f32
}

impl<'a> Button<'a> {
    pub fn new(font: &'a Font, button_type: ButtonType, pos: &Vector2f) -> Self {

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
            ButtonType::Play => {
                text.set_string("Play")
            }
            ButtonType::About => {
                text.set_string("About")
            }
        }

        text.set_position(*pos);

        Button {
            button_type: button_type,
            text: text,
            x: pos.x,
            y: pos.y
        }
    }
}

pub struct Menu<'a> {
    pub buttons: Vec<Button<'a>>,
}

impl<'a> Menu<'a> {
    pub fn draw(&mut self, rw: &mut RenderWindow) {
        for button in &self.buttons {
            rw.draw(&button.text);
        }
    }
}
