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

pub fn create(supplier: sf.RenderWindow, game: *Game) Self {
    return Self {
        .callbacksMap = std.AutoHashMap([250]u8, usize).init(std.heap.page_allocator),
        .supplier = supplier,
        .gameEventsBuffer = std.ArrayList(GameEvent).init(std.heap.page_allocator),
        .source = game
    };
}

pub fn update(self: *Self) !void {
    while (self.pollEvent()) |event| {
        
        var callbackPtrAddres: ?usize = self.callbacksMap.get(try event.toStr());

        if (callbackPtrAddres == null) { continue; }
        
        var callBackPtr: fn(*Game) anyerror!void = @intToPtr((fn(*Game) anyerror!void), callbackPtrAddres.?);
        
        try callBackPtr(self.source);
    }
}

pub fn registerCallback(self: *Self, callback: fn(*Game) anyerror!void, event: EventWrapper) !void {
    try self.callbacksMap.put(try event.toStr(), @ptrToInt(callback));
}

pub fn putGameEvent(self: *Self, event: GameEvent) void {
    self.gameEventsBuffer.append(event);
}

pub fn pollEvent(self: *Self) ?EventWrapper {
    var event: ?sf.Event = self.supplier.pollEvent();
    
    if (event == null) {
        var event_: ?GameEvent = self.gameEventsBuffer.popOrNull();
        
        if (event_ == null) {
            return null;
        } else
        
        {
            return EventWrapper{.gameEvent=event_.?};
        }
    } else {
        return EventWrapper{.sfmlEvent=event.?};
    }
}

callbacksMap: std.AutoHashMap([250]u8, usize),
supplier: sf.RenderWindow,
gameEventsBuffer: std.ArrayList(GameEvent),
source: *Game