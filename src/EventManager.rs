//extern crate sfml;

use sfml::{graphics::RenderWindow, window::Event, *};// 
use std::slice::Iter;

pub struct EventDispatcher {
    events: Vec<Event>,
}
impl EventDispatcher {
    pub fn new() -> EventDispatcher {
        EventDispatcher { events: Vec::new() }
    }

    pub fn update(&mut self, window: &mut RenderWindow) {
        while let Some(event) = window.poll_event() {
            self.events.push(event)
        }
    }

    pub fn has_event(&self, event: &Event) -> bool {
        self.events.contains(event)
    }

    pub fn clear_events(&mut self) {
        self.events.clear();
        
    }

    pub fn get_events(&self) -> Iter<Event> {
        self.events.iter()
    }
}