const std = @import("std");

const sf = struct {
    usingnamespace @import("sfml");
    usingnamespace sf.graphics;
    usingnamespace sf.window;
    usingnamespace sf.system;
};

pub fn main() !void {
    var window = try sf.RenderWindow.createDefault(.{ .x = 200, .y = 200 }, "SFML works!");
    errdefer window.destroy();
    while (true){
        window.display();
    }
}