// Simple event manager

const Self = @This();
const std = @import("std");

const Game = @import("game.zig");
// Callback function signature:
// fn(*Game, Event) !void 