#![allow(warnings, unused)]
use sfml::{
    graphics::{ 
        Color, Font, RectangleShape, RenderStates, RenderTarget, RenderWindow, Shape, Sprite,
        Texture, Transformable,
    },
    system::{Clock, Vector2, Vector2f},
    window::{mouse, ContextSettings, Event, Key, Style},
    SfBox,
};
use std::time::{Duration, Instant};

mod menu;
use menu::*;
mod resource_manager;
use resource_manager::*;
mod player_tank;
use player_tank::*;
mod state_stack;
use state_stack::{StateStack, StateType};
mod map;
use map::*;
mod EventManager;
use EventManager::EventDispatcher;

//___________________ INIT_GLOBAL_CONSTANTS_BEGIN ________//
const PI: f32 = std::f32::consts::PI;
//___________________ INIT_GLOBAL_CONSTANTS_END __________//

fn main() {
    
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

    //___________________ CREATING_EVENT_DISPATCHER_BEGIN ____//
    let mut event_manager = EventDispatcher::new();
    //___________________ CREATING_EVENT_DISPATCHER_END ______//

    //___________________ CREATING_TEXTURES_BEGIN ____________//
    let mut texture_manager = TextureManager::new();
    texture_manager.load(TextureIdentifiers::Tank, "resources/tank.png");
    texture_manager.load(TextureIdentifiers::Turret, "resources/turret.png");
    texture_manager.load(TextureIdentifiers::Ground, "resources/ground.png");
    //___________________ CREATING_TEXTURES_END ______________//

    //___________________ CREATING_FONTS_BEGIN _______________//
    let mut font_manager = FontManager::new();
    font_manager.load(FontIdentifiers::sansation, "resources/sansation.ttf");
    //___________________ CREATING_FONTS_END _________________//

    //___________________ CREATING_MAP_BEGIN _________________//
    let mut map = Map::new();
    map.tile
        .sprite
        .set_texture(&texture_manager.get(TextureIdentifiers::Ground), false);
    //___________________ CREATING_MAP_END ___________________//

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

    //___________________ CREATING_SHADOW_BEGIN ________________//
    let mut shadow = RectangleShape::new();
    shadow.set_size((1000f32, 700f32));
    shadow.set_position((0f32, 0f32));
    shadow.set_fill_color(Color::rgba(0, 0, 0, 100));
    //___________________ CREATING_SHADOW_END __________________//

    //___________________ CREATING_MENU_END ____________________//

    // Some Prelude
    map.render_all(&PlayerTank, &mut window, &states);
    // End 

    'mainl: loop {

        event_manager.update(&mut window);

        match *state_stack.top().unwrap() {
            StateType::Intro => {}
            StateType::Menu => {}
            StateType::Pause => {
                //Типо ресетим цвет кнопки (подлежит рефакторингу)
                menu.buttons[0].text.set_fill_color(Color::WHITE);
                menu.buttons[1].text.set_fill_color(Color::WHITE);

                let mpos = window.mouse_position(); // Типо позиция мыши

                if menu.buttons[0]
                    .text
                    .global_bounds()
                    .contains2(mpos.x as f32, mpos.y as f32)
                {
                    if mouse::Button::is_pressed(mouse::Button::LEFT) {
                        state_stack.pop();
                        state_stack.push(StateType::Playing);
                        //println!("{:?}", state_stack);
                        //window.clear(Color::BLACK);
                        map.render_all(&PlayerTank, &mut window, &states);
                        continue;
                    }
                    menu.buttons[0].text.set_fill_color(Color::MAGENTA);
                };
                if menu.buttons[1]
                    .text
                    .global_bounds()
                    .contains2(mpos.x as f32, mpos.y as f32)
                {
                    if mouse::Button::is_pressed(mouse::Button::LEFT) {
                        break 'mainl;
                    }
                    menu.buttons[1].text.set_fill_color(Color::MAGENTA);
                };
                //window.draw_rectangle_shape(&shadow, &states);
                menu.draw(&mut window);
            }
            StateType::Playing => {

                let mut buf = event_manager.get_events(); // buffer of events

                //___________________ RENDER_MAP_BEGIN _________________//
                
                map.render(&PlayerTank, &mut window, &states);

                //___________________ RENDER_MAP_END ___________________//
                
                //___________________ HANDLING_KEYBOARD_BEGIN __________//

                PlayerTank.update_pos();
                window.draw_sprite(&PlayerTank.sprite, &states);
                window.draw_sprite(&PlayerTank.tsprite, &states);

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
                }
                if sfml::window::Key::DOWN.is_pressed() {
                    PlayerTank.x += PlayerTank.speed * (PlayerTank.angle * PI / 180.0).cos();
                    PlayerTank.y += PlayerTank.speed * (PlayerTank.angle * PI / 180.0).sin();
                }

                while let Some(event) = buf.next() {
                    match event {
                        Event::MouseWheelScrolled { delta: -1.0, .. } => {
                            PlayerTank.tsprite.rotate(-6f32)
                        }
                        Event::MouseWheelScrolled { delta: 1.0, .. } => {
                            PlayerTank.tsprite.rotate(6f32)
                        }
                        _ => {
                            //println!("{:#?}", event)
                        }
                    }
                }
                //___________________ HANDLING_KEYBOARD_END ____________//
            }
            StateType::GameOver => {}
        }

        //___________________ HANDLING_ESCAPE_CLOSE_MENU_BEGIN ______//
        let mut buf = event_manager.get_events(); // buffer of events
        
        while let Some(event) = buf.next() {

            match event {
                Event::KeyPressed {
                    code: Key::ESCAPE, ..
                } => break 'mainl,
                Event::KeyPressed {
                    code: Key::P, ..
                } => {
                    state_stack.push(StateType::Pause);
                    window.draw_rectangle_shape(&shadow, &states);

                },
                Event::Closed => break 'mainl,
                _ => {}
            }
        }
        //___________________ HANDLING_ESCAPE_CLOSE_MENU_END ________//
        
        let start = Instant::now();
            window.display();
        let duration = start.elapsed().as_secs_f64();

        println!("FPS: {:?}", (1f64 / duration) as u32);

        event_manager.clear_events();
    }
}
