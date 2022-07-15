// Simple event manager

const Self = @This();
const std = @import("std");

const Game = @import("game.zig");
const EventWrapper = @import("eventWrapper.zig").EventWrapper;
// Callback function signature:
// fn(*Game, Event) !void 

pub fn update() void {}

pub fn registerCallback(callback: fn(*Game, EventWrapper), eventType) void {}

pub fn processEvent(event: EventWrapper) void {}

callbacksMap: std.AutoHashMap(EventWrapper, fn(*Game, EventWrapper))