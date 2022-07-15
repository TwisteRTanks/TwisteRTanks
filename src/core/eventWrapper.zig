const sf = @import("sf.zig");
const sfmlEvent = sf.Event;

const GameEvent = @import("core/gameEvent.zig").gameEvent;

const EventWrapper = union(enum) {
    sfmlEvent: sf.Event,
    gameEvent: GameEvent
}