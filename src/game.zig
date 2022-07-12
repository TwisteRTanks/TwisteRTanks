const Self = @This();
const print = @import("std").debug.print;
const sf = @import("sf");
const keyboard = sf.window.keyboard;

const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const Map = @import("map.zig");
const Button = @import("ui/button.zig").Button;
const Menu = @import("ui/menu.zig");

pub fn createGame() !Self {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    var map = Map.create();
    var master = try Tank.create();
    var gameMenu = Menu.create();

    return Self {
        .window = window,
        .map = map,
        .master = master,
        .gameMenu = gameMenu,
    };

}

pub fn setup(self: *Self) !void {
    self.window.setFramerateLimit(60);
    try self.map.genMap();
}

pub fn runMainLoop(self: *Self) !void {

    while (self.window.isOpen()) {
        
        window.clear(sf.Color.Black);
        try map.drawOnWindow(&window);
        tank.drawOnWindow(&window);
        window.display();
    
    }

}

pub fn destroyGame() !void {

}

window: sf.RenderWindow,
gameMenu: Menu,
master: Tank,
map: Map
