const std = @import("std");
const sf = @import("sf");
//const game = @import("game[deprecated].zig");
const game = @import("game.zig");
pub fn main() !void {
    _ = (try (try game.createGame()).runMainLoop());
    //_ = try game.mainloop();
}


