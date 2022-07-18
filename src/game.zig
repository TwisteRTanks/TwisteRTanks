const Game = @This();
const std = @import("std");
const print = @import("std").debug.print;
const sf = @import("sf");
const keyboard = sf.window.keyboard;

const EventWrapper = @import("core/eventWrapper.zig").EventWrapper;
const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const Map = @import("map.zig");
const Button = @import("ui/button.zig").Button;
const Menu = @import("ui/menu.zig");
const EventManager = @import("core/evmanager.zig");
const GameEvent = @import("core/gameEvent.zig").gameEvent;

pub fn createGame() !Game {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    var map = Map.create();
    var master = try Tank.create();
    var gameMenu = try Menu.create();
    var eventManager: ?EventManager = null;

    return Game {
        .window = window,
        .map = map,
        .master = master,
        .gameMenu = gameMenu,
        .cEventManager = eventManager,
    };

}

pub fn simpleCallback(game: *Game) anyerror!void {
    game.window.close();
}

pub fn setup(game: *Game) !void {
    game.window.setFramerateLimit(60);
    try game.map.genMap();
    game.cEventManager = EventManager.create(game.window, game);
    try game.cEventManager.?.registerCallback(simpleCallback, EventWrapper{.sfmlEvent=sf.Event.closed});
}

pub fn runMainLoop(self: *Game) !void {
    while (self.window.isOpen()) {
        try self.cEventManager.?.update();
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
map: Map,
cEventManager: ?EventManager