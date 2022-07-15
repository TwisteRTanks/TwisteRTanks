const std = @import("std");
const game = @import("game.zig");

pub fn main() !void {
    _ = try game.runMainLoop();
}
