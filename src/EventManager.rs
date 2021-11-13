extern crate sfml;
use sfml::{graphics::RenderWindow, window::Event, *};

pub struct EventDispatcher {
    // Original code by linux-admin
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
}
