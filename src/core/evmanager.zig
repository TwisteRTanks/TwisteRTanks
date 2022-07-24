// Simple event manager
// Zig version: 0.10.0-dev.2424+b3672e073 
// Code by @<https://github.com/linux-admin0001>

const Self = @This();
const std = @import("std");

const sf = @import("sf");
const Game = @import("../game.zig");
const EventWrapper = @import("eventWrapper.zig").EventWrapper;
const GameEvent = @import("gameEvent.zig").gameEvent;
const HashMap = std.HashMap;

// Callback function signature:
// fn(*Game, EventWrapper) !void 

pub fn create(supplier: sf.RenderWindow, game: *Game) Self {
    return Self {
        .callbacksMap = std.AutoHashMap([250]u8, usize).init(std.heap.page_allocator),
        .genericCallbacksMap = std.StringHashMap(std.ArrayList(usize)).init(std.heap.page_allocator),
        .supplier = supplier,
        .gameEventsBuffer = std.ArrayList(GameEvent).init(std.heap.page_allocator),
        .allEventsBuffer = std.ArrayList(EventWrapper).init(std.heap.page_allocator),
        .source = game
    };
}

pub fn update(self: *Self) !void {
    while (try self.pollEvent()) |event| {
        // `source` is the *Game

        const eventName = switch (event) {
            EventWrapper.sfmlEvent => event.getEventName(),
            else => event.getEventName()
        };

        var callbackPtrAddres: ?usize = self.callbacksMap.get(try event.toStr());
        var genericCallbacksPtrAddres: ?std.ArrayList(usize) = self.genericCallbacksMap.get(eventName);

        if (genericCallbacksPtrAddres != null) {
            for (genericCallbacksPtrAddres.?.items) |cbPtrAdress| {
                const binding: fn(*Game, EventWrapper) anyerror!void = @intToPtr(fn(*Game, EventWrapper) anyerror!void, cbPtrAdress);
                try binding(self.source, event);
            }
        }

        if (callbackPtrAddres == null) { continue; }
        
        var callBackPtr: fn(*Game) anyerror!void = @intToPtr((fn(*Game) anyerror!void), callbackPtrAddres.?);
        
        try callBackPtr(self.source);
    }
}

pub fn registerCallback(self: *Self, callback: fn(*Game) anyerror!void, event: EventWrapper) !void {
    try self.callbacksMap.put(try event.toStr(), @ptrToInt(callback));
}

pub fn registerGenericCallback(self: *Self, callback: fn(*Game, EventWrapper) anyerror!void, event: EventWrapper) !void {
    const eventName = switch (event) {
        EventWrapper.sfmlEvent => event.getEventName(),
        else => event.getEventName()
    };
    std.debug.print("{s}\n", .{eventName});
    var bindingsArray: ?std.ArrayList(usize) = self.genericCallbacksMap.get(eventName);
    if (bindingsArray == null) {
        var newArrayList = std.ArrayList(usize).init(std.heap.page_allocator);
        try newArrayList.append(@ptrToInt(callback));
        try self.genericCallbacksMap.put(eventName, newArrayList);
    } else {
        try bindingsArray.?.append(@ptrToInt(callback));
    }
    
}
pub fn putGameEvent(self: *Self, event: GameEvent) !void {
    try self.gameEventsBuffer.append(event);
}

pub fn pollEvent(self: *Self) !?EventWrapper {
    var event: ?sf.Event = self.supplier.pollEvent();
    
    if (event == null) {
        var event_: ?GameEvent = self.gameEventsBuffer.popOrNull();
        
        if (event_ == null) {
            return null;
        } else
        
        {
            try self.allEventsBuffer.append(EventWrapper{.gameEvent=event_.?});
            return EventWrapper{.gameEvent=event_.?};
        }
    } else {
        try self.allEventsBuffer.append(EventWrapper{.sfmlEvent=event.?});
        return EventWrapper{.sfmlEvent=event.?};
    }
}

callbacksMap: std.AutoHashMap([250]u8, usize),
// {"mouseButtonPressed": [binding1, binding2, ...]}
// second argument (usize) is addres of *fn(*Game, EventWrapper) anyerror!void
genericCallbacksMap: std.StringHashMap(std.ArrayList(usize)),
supplier: sf.RenderWindow,
gameEventsBuffer: std.ArrayList(GameEvent),
allEventsBuffer: std.ArrayList(EventWrapper),
source: *Game