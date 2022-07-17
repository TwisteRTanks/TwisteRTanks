// Simple event manager

const Self = @This();
const std = @import("std");

const sf = @import("sf");
const Game = @import("../game.zig");
const EventWrapper = @import("eventWrapper.zig").EventWrapper;
const GameEvent = @import("gameEvent.zig").gameEvent;
const HashMap = std.HashMap;
// Callback function signature:
// fn(*Game) !void 

pub fn create(supplier: sf.RenderWindow) Self {
    return Self {
        .callbacksMap = std.AutoHashMap(i128, usize).init(std.heap.page_allocator),
        .supplier = supplier,
        .gameEventsBuffer = std.ArrayList(GameEvent).init(std.heap.page_allocator)
    };
}

pub fn update(self: Self) void {
    while (self.pollEvent()) |event| {
        var callback = self.callbacksMap.get(event.toInt());    
        _=callback;
    }
}

pub fn registerCallback(self: *Self, callback: fn(*Game) anyerror!void, event: EventWrapper) !void {
    try self.callbacksMap.put(event.toInt(), @ptrToInt(&callback));
}

pub fn putGameEvent(self: *Self, event: GameEvent) void {
    self.gameEventsBuffer.append(event);
}

pub fn pollEvent(self: *Self) EventWrapper {
    var event: sf.Event = self.supplier.pollEvent();
    
    if (event == null) {
        var event_: sf.EventWrapper = self.evBuffer.pop();
        return EventWrapper{.gameEvent=event_};
    } else {
        return EventWrapper{.sfmlEvent=event};
    }
}

callbacksMap: std.AutoHashMap(i128, usize),
supplier: sf.RenderWindow,
gameEventsBuffer: std.ArrayList(GameEvent)