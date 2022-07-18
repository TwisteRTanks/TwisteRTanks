// Keyboard manager
const Self = @This();
const std = @import("std");

const sf = @import("sf");
const Game = @import("../game.zig");
const EventWrapper = @import("eventWrapper.zig").EventWrapper;
const GameEvent = @import("gameEvent.zig").gameEvent;
const HashMap = std.HashMap;

pub fn addReactOnKey(self: *Self, binding: fn(*Game) anyerror!void, key: sf.Keyboard.KeyCode) !void {
    try self.keyMap.put(key, @ptrToInt(binding));
}

pub fn create(source: *Game) !Self {
    return Self {
        .keyMap = std.AutoHashMap(sf.window.keyboard.KeyCode, usize).init(std.heap.page_allocator),
        .source = source
    };
}

pub fn update(self: *Self) !void {
    for (self.keyMap.keys) |kcode| {
        if sf.window.keyboard.isKeyPressed(kcode) {
           var bindFuncPtrAddr: usize = self.keyMap.get(kcode).?;
           var bindFunc = @intToPtr(fn(*Game) anyerror!void, bindFuncPtrAddr);
           try bindFunc(self.source);
        };
    };
}

keyMap: std.AutoHashMap(sf.window.keyboard.KeyCode, usize),
source: *Game