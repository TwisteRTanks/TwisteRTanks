const sf = @import("sf");
const sfmlEvent = sf.Event;

const GameEvent = @import("gameEvent.zig").gameEvent;

pub const EventWrapper = union(enum) {
    sfmlEvent: sf.Event,
    gameEvent: GameEvent,

    pub fn toStr(self: EventWrapper) ![250]u8 {
        return switch (self) {
            EventWrapper.sfmlEvent => try self.sfmlEvent.toStr(),
            EventWrapper.gameEvent => try self.gameEvent.toStr()
        };
    }

    pub fn getEventName(self: EventWrapper) []const u8 {
        return switch (self) {
            EventWrapper.sfmlEvent => self.sfmlEvent.getEventName(),
            EventWrapper.gameEvent => self.gameEvent.getEventName()
        };
    }
};