const Game = @This();
const std = @import("std");
const print = @import("std").debug.print;

const sf = @import("sf");
const keyboard = sf.window.keyboard;
const KeyCode = keyboard.KeyCode;

const EventWrapper = @import("core/eventWrapper.zig").EventWrapper;
const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const Map = @import("map.zig");
const Button = @import("ui/button.zig").Button;
const Menu = @import("ui/menu.zig");
const EventManager = @import("core/evmanager.zig");
const KeyboardManager = @import("core/kbmanager.zig");
const GameEvent = @import("core/gameEvent.zig").gameEvent;
const bindings = @import("bindings.zig");

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
        bindings.onCloseWindow, 
        EventWrapper{ .sfmlEvent = sf.Event.closed }
    );

    // Creating and setuping keyboard manager //
    self.cKeyboardManager = KeyboardManager.create(self);
    // Todo: refactor this code
    try self.cKeyboardManager.?.addReactOnKey(bindings.onLeftKeyPressed, KeyCode.Left);
    try self.cKeyboardManager.?.addReactOnKey(bindings.onRightKeyPressed, KeyCode.Right);
    try self.cKeyboardManager.?.addReactOnKey(bindings.onUpKeyPressed, KeyCode.Up);
    try self.cKeyboardManager.?.addReactOnKey(bindings.onDownKeyPressed, KeyCode.Down);
    try self.cKeyboardManager.?.addReactOnKey(bindings.onWKeyPressed, KeyCode.W);
    try self.cKeyboardManager.?.addReactOnKey(bindings.onSKeyPressed, KeyCode.S);
}

pub fn runMainLoop(self: *Game) !void {
    var b = try Button.create(.{100, 100}, "Test", &self.window);
    
    while (self.window.isOpen()) {
        b.update();
        try self.cEventManager.?.update();
        try self.cKeyboardManager.?.update();

        self.window.clear(sf.Color.Black);
        self.map.drawOnWindow(&self.window);
        self.master.drawOnWindow(&self.window);
        b.drawOnWindow(&self.window);
        self.window.display();
    }
}

pub fn destroyGame() !void {}

window: sf.RenderWindow,
gameMenu: Menu,
master: Tank,
map: Map,
cEventManager: ?EventManager,
cKeyboardManager: ?KeyboardManager
