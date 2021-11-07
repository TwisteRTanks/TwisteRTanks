#![allow(warnings, unused)]

use sfml::{
    graphics::{
        Color, Font, RenderStates, RenderTarget, RenderWindow, Sprite, Texture, Transformable,
    },
    system::{Clock, Vector2, Vector2f},
    window::{mouse, ContextSettings, Event, Key, Style},
    SfBox,
};

use std::{borrow::Borrow, collections::HashMap};

mod menu;
use menu::*;
mod resource_manager;
use resource_manager::*;
mod player_tank;
use player_tank::*;
mod state_stack;
use state_stack::{StateStack, StateType};

//___________________ INIT_GLOBAL_CONSTANTS_BEGIN ________//
const PI: f32 = std::f32::consts::PI;
//___________________ INIT_GLOBAL_CONSTANTS_END __________//

fn main() {
    let t = Option::<i32>::None;
    //___________________ INIT_STATE_STACK_BEGIN _____________//
    let mut state_stack = StateStack::new();
    state_stack.push(StateType::Playing);
    //___________________ INIT_STATE_STACK_END _______________//

    //___________________ CREATING_WINDOW_BEGIN ______________//
    let mut window = RenderWindow::new(
        (1000, 700),
        "TwisteRTanks",
        Style::CLOSE,
        &ContextSettings::default(),
    );
    let states = RenderStates::default();
    //___________________ CREATING_WINDOW_END ________________//

    //___________________ CREATING_TEXTURES_BEGIN ____________//
    let mut texture_manager = TextureManager::new();
    texture_manager.load(TextureIdentifiers::Tank, "resources/tank.png");
    texture_manager.load(TextureIdentifiers::Turret, "resources/turret.png");
    //___________________ CREATING_TEXTURES_END ______________//

    //___________________ CREATING_FONTS_BEGIN _______________//
    let mut font_manager = FontManager::new();
    font_manager.load(FontIdentifiers::sansation, "resources/sansation.ttf");
    //___________________ CREATING_FONTS_END _________________//

    //___________________ CREATING_PLAYER_BEGIN ______________//
    let mut PlayerTank = Tank::new();
    PlayerTank
        .sprite
        .set_texture(&texture_manager.get(TextureIdentifiers::Tank), false);
    PlayerTank
        .tsprite
        .set_texture(&texture_manager.get(TextureIdentifiers::Turret), false);

    PlayerTank.sprite.set_origin((22f32, 40f32));
    PlayerTank.tsprite.set_origin((13f32, 34f32));
    //___________________ CREATING_PLAYER_END ________________//

    //___________________ CREATING_MENU_BEGIN ________________//
    let mut menu = Menu {
        buttons: vec![
            Button::new(
                (font_manager.get(FontIdentifiers::sansation)),
                ButtonType::Resume,
                &Vector2f::new(400., 180.),
            ),
            Button::new(
                font_manager.get(FontIdentifiers::sansation),
                ButtonType::Quit,
                &Vector2f::new(440., 180. + 80.),
            ),
        ],
    };
    //___________________ CREATING_MENU_END __________________//
    'mainl: loop {
        
        //Типо ресетим цвет кнопки (подлежит рефакторингу)
        menu.buttons[0].text.set_fill_color(Color::WHITE);
        menu.buttons[1].text.set_fill_color(Color::WHITE);

        let mpos = window.mouse_position(); // Типо позиция мыши

        if menu.buttons[0]
            .text
            .global_bounds()
            .contains2(mpos.x as f32, mpos.y as f32)
        {
            menu.buttons[0].text.set_fill_color(Color::MAGENTA);
        };
        if menu.buttons[1]
            .text
            .global_bounds()
            .contains2(mpos.x as f32, mpos.y as f32)
        {
            menu.buttons[1].text.set_fill_color(Color::MAGENTA);
        };

        //___________________ HANDLING_KEYBOARD_BEGIN __________//

        if sfml::window::Key::LEFT.is_pressed() {
            PlayerTank.sprite.rotate(-2f32);
            PlayerTank.tsprite.rotate(-2f32);
            PlayerTank.angle -= 2f32
        }
        if sfml::window::Key::RIGHT.is_pressed() {
            PlayerTank.sprite.rotate(2f32);
            PlayerTank.tsprite.rotate(2f32);
            PlayerTank.angle += 2f32
        }
        if sfml::window::Key::UP.is_pressed() {
            PlayerTank.x -= PlayerTank.speed * (PlayerTank.angle * PI / 180.0).cos();
            PlayerTank.y -= PlayerTank.speed * (PlayerTank.angle * PI / 180.0).sin();
            //tx -= speed * (angle * PI / 180.0).cos();
            //ty -= speed * (angle * PI / 180.0).sin();
        }
        if sfml::window::Key::DOWN.is_pressed() {
            PlayerTank.x += PlayerTank.speed * (PlayerTank.angle * PI / 180.0).cos();
            PlayerTank.y += PlayerTank.speed * (PlayerTank.angle * PI / 180.0).sin();
            //tx += speed * (angle * PI / 180.0).cos();
            //ty += speed * (angle * PI / 180.0).sin();
        }
        while let Some(event) = window.poll_event() {
            match event {
                Event::MouseWheelScrolled { delta: -1.0, .. } => PlayerTank.tsprite.rotate(-6f32),
                Event::MouseWheelScrolled { delta: 1.0, .. } => PlayerTank.tsprite.rotate(6f32),
                Event::KeyPressed {
                    code: Key::ESCAPE, ..
                } => break 'mainl,
                Event::Closed => break 'mainl,
                _ => {
                    //println!("{:#?}", event)
                }
            }
        }
        //___________________ HANDLING_KEYBOARD_END ____________//
        
        PlayerTank.update_pos();
        window.draw_sprite(&PlayerTank.sprite, &states);
        window.draw_sprite(&PlayerTank.tsprite, &states);
        menu.draw(&mut window);
        window.display();
    }
}
