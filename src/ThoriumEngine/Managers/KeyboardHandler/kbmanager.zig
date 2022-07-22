// Keyboard manager
const Self = @This();
const std = @import("std");

const sf = @import("sf");
const Game = @import("../game.zig");
const EventWrapper = @import("eventWrapper.zig").EventWrapper;
const GameEvent = @import("gameEvent.zig").gameEvent;
const HashMap = std.HashMap;

pub fn addReactOnKey(self: *Self, binding: fn(*Game) anyerror!void, key: sf.keyboard.KeyCode) !void {
    try self.keyMap.put(key, @ptrToInt(binding));
}

pub fn create(source: *Game) Self {
    return Self {
        .keyMap = std.AutoHashMap(sf.window.keyboard.KeyCode, usize).init(std.heap.page_allocator),
        .source = source
    };
}

pub fn update(self: *Self) !void {

    var it = self.keyMap.iterator();

    while (it.next()) |kv| {
        var kcode: sf.window.keyboard.KeyCode = kv.key_ptr.*;
        var bindingAddr: usize = kv.value_ptr.*;
        var binding: fn(*Game) anyerror!void = @intToPtr(fn(*Game) anyerror!void, bindingAddr);
        
        if (sf.window.keyboard.isKeyPressed(kcode)) {
            try binding(self.source);
        }
    
    }
}

keyMap: std.AutoHashMap(sf.window.keyboard.KeyCode, usize),
source: *Game