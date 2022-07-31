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
const gameEvent = @import("core/gameEvent.zig").gameEvent;
const bindings = @import("bindings.zig");
const UIDManager = @import("uidmanager.zig");
const Scene = @import("ui/scene.zig");

pub fn createGame() !Game {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    var map = Map.create();
    var master = try Tank.create();
    var gameMenu = try Menu.create("Main Menu", sf.Vector2f.new(0,0));
    var eventManager: ?EventManager = null;
    var keyboardManager: ?KeyboardManager = null;

    return Game { 
        .uidmanager = UIDManager.create(),
        .window = window, 
        .map = map, 
        .master = master, 
        .gameMenu = gameMenu, 
        .cEventManager = eventManager, 
        .cKeyboardManager = keyboardManager,
        //.buttons = std.ArrayList(Button).init(std.heap.page_allocator),
        .buttons = try std.ArrayList(*Button).initCapacity(std.heap.page_allocator, 50),
    };
}

pub fn setup(self: *Game) !void {
    var scene = try Scene.create();
    _=scene;
    self.window.setFramerateLimit(60);

    try self.map.genMap();

    // Creating and setuping event manager //
    self.cEventManager = EventManager.create(self.window, self);

    try self.cEventManager.?.registerCallback(
        bindings.onCloseWindow, 
        EventWrapper{ .sfmlEvent = sf.Event.closed }
    );

    var ev_: sf.Event.MouseButtonEvent = undefined;

    try self.cEventManager.?.registerGenericCallback(
        bindings.onMouseButtonLeftPressed, 
        EventWrapper{ .sfmlEvent = sf.Event{ .mouseButtonPressed = ev_} }
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
    
    // Creating the button instance
    var clsButton = try Button.create(
        self,
        .{0, 0}, 
        "Close",
        sf.Vector2f{.x=400, .y=57}
    );
    var helpButton = try Button.create(
        self,
        .{0, 300}, 
        "Help",  
        sf.Vector2f{.x=400, .y=57}
    );
    // Q: Why do we put the button in heap?
    // A: this way she will keep her lifetime until we manually free her memory
    // A: Ok, but we could just take &clsButton
    // Q: Yes, but the pointer to clsButton would be destroyed with the stack frame of the function
    // Q: And this would lead to segmentation faults
    // A: But we could just put the Button in the ArrayList (self.buttons)?
    // Q: But it's not productive,
    // Q: because when new elements are added to the ArrayList, 
    // Q: it allocates new memory, and **copies** all its elements to the allocated memory
    // Q: Which is more profitable: copying a pointer or an instance of a Button?
    const clsButtonPtr = try std.heap.page_allocator.create(Button);
    clsButtonPtr.* = clsButton;
    try self.buttons.append(clsButtonPtr);
    
    const helpButtonPtr = try std.heap.page_allocator.create(Button);
    helpButtonPtr.* = helpButton;
    try self.buttons.append(helpButtonPtr);

    try self.cEventManager.?.registerCallback(
        bindings.onCloseButtonPressed, 
        EventWrapper{ 
            .gameEvent = gameEvent{.buttonPressed = .{.id = clsButton.id}}
        }
    );

    try self.cEventManager.?.registerCallback(
        bindings.onHelpButtonPressed, 
        EventWrapper{ 
            .gameEvent = gameEvent{.buttonPressed = .{.id = helpButton.id}}
        }
    );
}

pub fn runMainLoop(self: *Game) !void {

    while (self.window.isOpen()) {
        try self.cEventManager.?.update();
        try self.cKeyboardManager.?.update();        
        self.window.clear(sf.Color.Black);
        self.map.drawOnWindow(&self.window);
        self.master.drawOnWindow(&self.window);
        
        // button and so the pointer, so it is mutable (don't do that: *button)
        for (self.buttons.items) |buttonPtr| {
            buttonPtr.update();
            buttonPtr.drawOnWindow(&self.window);
        }
        
        self.window.display();

    }
}

pub fn destroyGame(self: *Game) !void {
    // freeing up memory
    self.window.destroy();  
    self.cEventManager.?.destroy();
    self.cKeyboardManager.?.destroy();

    for (self.buttons.items) |buttonPtr| {
        std.heap.page_allocator.destroy(buttonPtr);
    }

    self.buttons.deinit();
    self.master.destroy();
}
uidmanager: UIDManager,
window: sf.RenderWindow,
master: Tank,
map: Map,
cEventManager: ?EventManager,
cKeyboardManager: ?KeyboardManager,
// Gui elements:
buttons: std.ArrayList(*Button),
gameMenu: Menu,
//labels: ...
//inputFiels: ...
