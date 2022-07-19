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
const KeyboardManager = @import("core/kbmanager.zig");
const GameEvent = @import("core/gameEvent.zig").gameEvent;

pub fn createGame() !Game {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    var map = Map.create();
    var master = try Tank.create();
    var gameMenu = try Menu.create();
    var eventManager: ?EventManager = null;
    var keyboardManager: ?KeyboardManager = null;

    return Game {
        .window = window,
        .map = map,
        .master = master,
        .gameMenu = gameMenu,
        .cEventManager = eventManager,
        .cKeyboardManager = keyboardManager
    };

}

pub fn setup(self: *Game) !void {
    self.window.setFramerateLimit(60);

    try self.map.genMap();

    // Creating and setuping event manager //
    self.cEventManager = EventManager.create(self.window, self);
    
    try self.cEventManager.?.registerCallback(
        onCloseWindow, 
        EventWrapper{.sfmlEvent=sf.Event.closed}
    );
    
    // Creating and setuping keyboard manager //
    self.cKeyboardManager = KeyboardManager.create(self);

    // Todo: refactor this code
    try self.cKeyboardManager.?.addReactOnKey(
        onLeftKeyPressed,
        sf.window.keyboard.KeyCode.Left
    );

    try self.cKeyboardManager.?.addReactOnKey(
        onRightKeyPressed,
        sf.window.keyboard.KeyCode.Right
    );

    try self.cKeyboardManager.?.addReactOnKey(
        onUpKeyPressed,
        sf.window.keyboard.KeyCode.Up
    );

    try self.cKeyboardManager.?.addReactOnKey(
        onDownKeyPressed,
        sf.window.keyboard.KeyCode.Down
    );

    try self.cKeyboardManager.?.addReactOnKey(
        onWKeyPressed,
        sf.window.keyboard.KeyCode.W
    );

    try self.cKeyboardManager.?.addReactOnKey(
        onSKeyPressed,
        sf.window.keyboard.KeyCode.S
    );
}

pub fn runMainLoop(self: *Game) !void {
    while (self.window.isOpen()) {

        try self.cEventManager.?.update();
        try self.cKeyboardManager.?.update();
        self.window.clear(sf.Color.Black);
        try self.map.drawOnWindow(&self.window);
        self.master.drawOnWindow(&self.window);
        self.window.display();
    
    }

}

pub fn destroyGame() !void {}

// ================== Callbacks and bindings section ================== //
// Generic signature: fn(*Game) anyerror! void

pub fn onCloseWindow(game: *Game) anyerror!void {
    game.window.close();
}

pub fn onLeftKeyPressed(game: *Game) anyerror!void {
    game.master.rotate(-1);
}

pub fn onRightKeyPressed(game: *Game) anyerror!void {
    game.master.rotate(1);
}

pub fn onUpKeyPressed(game: *Game) anyerror!void {
    game.master.gas(1);
}

pub fn onDownKeyPressed(game: *Game) anyerror!void {
    game.master.gas(-1);
}

pub fn onWKeyPressed(game: *Game) anyerror!void {
    game.master.rotateTurret(1);
}

pub fn onSKeyPressed(game: *Game) anyerror!void {
    game.master.rotateTurret(-1);
}

// ================== Callbacks and bindings section ================== //

window: sf.RenderWindow,
gameMenu: Menu,
master: Tank,
map: Map,
cEventManager: ?EventManager,
cKeyboardManager: ?KeyboardManager