const sf = @import("sf");
const sfmlEvent = sf.Event;

const GameEvent = @import("gameEvent.zig").gameEvent;

pub const EventWrapper = union(enum) {
    sfmlEvent: sf.Event,
    gameEvent: GameEvent,

    pub fn toInt(self: EventWrapper) i128 {
        return switch (self) {
            EventWrapper.sfmlEvent => self.sfmlEvent.toInt(),
            EventWrapper.gameEvent => self.gameEvent.toInt()
        };
    }

};