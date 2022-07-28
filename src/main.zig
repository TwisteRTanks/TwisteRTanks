const std = @import("std");
const sf = @import("sf");
const Game = @import("game.zig");

pub fn main() !void {
    var game = try Game.createGame();
    try game.setup();
    try game.runMainLoop();
    try game.destroyGame();

}


