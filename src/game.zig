const Self = @This();
const print = @import("std").debug.print;
const sf = @import("sf");
const keyboard = sf.window.keyboard;

const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const Map = @import("map.zig");
const Button = @import("ui/button.zig").Button;
const Menu = @import("ui/menu.zig");
const EventManager = @import("core/evmanager.zig");
const GameEvent = @import("core/gameEvent.zig").gameEvent;

pub fn createGame() !Self {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    var map = Map.create();
    var master = try Tank.create();
    var gameMenu = try Menu.create();

    var buttonev =  GameEvent{.buttonPressed = .{.id = 3}};
    var buttonev2 = GameEvent{.buttonPressed = .{.id = 4}};
    var sfev = sf.Event{.mouseWheelScrolled = .{.wheel=.Vertical, .delta = 0.7, .pos=.{.x=2, .y=5}}};
    _=sfev;
    print("{any}\n", .{buttonev.toInt()});
    print("{any}", .{buttonev2.toInt()});
    print("{any}", .{sfev.toInt()});
    _=EventManager.create(window);
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
        while (self.window.pollEvent()) |event| {
            print("{any}\n", .{event.toInt()});
            if (event == .closed)
                
                self.window.close();
        }
        self.window.clear(sf.Color.Black);
        try self.map.drawOnWindow(&self.window);
        self.master.drawOnWindow(&self.window);
        self.window.display();
    
    }

}

pub fn destroyGame() !void {

}

window: sf.RenderWindow,
gameMenu: Menu,
master: Tank,
map: Map
