const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
};


pub const Event = union(Event.Type) {
    const Self = @This();

    pub const Type = enum(c_int) {
        closed,
        resized,
        lostFocus,
        gainedFocus,
        textEntered,
        keyPressed,
        keyReleased,
        mouseWheelScrolled,
        mouseButtonPressed,
        mouseButtonReleased,
        mouseMoved,
        mouseEntered,
        mouseLeft
    };

    // Big oof
    /// Creates this event from a csfml one
    pub fn _fromCSFML(event: sf.c.sfEvent) Self {
        return switch (event.type) {
            sf.c.sfEvtClosed => .{ .closed = {} },
            sf.c.sfEvtResized => .{ .resized = .{ .size = .{ .x = event.size.width, .y = event.size.height } } },
            sf.c.sfEvtLostFocus => .{ .lostFocus = {} },
            sf.c.sfEvtGainedFocus => .{ .gainedFocus = {} },
            sf.c.sfEvtTextEntered => .{ .textEntered = .{ .unicode = event.text.unicode } },
            sf.c.sfEvtKeyPressed => .{ .keyPressed = .{ .code = @intToEnum(sf.window.keyboard.KeyCode, event.key.code), .alt = (event.key.alt != 0), .control = (event.key.control != 0), .shift = (event.key.shift != 0), .system = (event.key.system != 0) } },
            sf.c.sfEvtKeyReleased => .{ .keyReleased = .{ .code = @intToEnum(sf.window.keyboard.KeyCode, event.key.code), .alt = (event.key.alt != 0), .control = (event.key.control != 0), .shift = (event.key.shift != 0), .system = (event.key.system != 0) } },
            sf.c.sfEvtMouseWheelScrolled => .{ .mouseWheelScrolled = .{ .wheel = @intToEnum(sf.window.mouse.Wheel, event.mouseWheelScroll.wheel), .delta = event.mouseWheelScroll.delta, .pos = .{ .x = event.mouseWheelScroll.x, .y = event.mouseWheelScroll.y } } },
            sf.c.sfEvtMouseButtonPressed => .{ .mouseButtonPressed = .{ .button = @intToEnum(sf.window.mouse.Button, event.mouseButton.button), .pos = .{ .x = event.mouseButton.x, .y = event.mouseButton.y } } },
            sf.c.sfEvtMouseButtonReleased => .{ .mouseButtonReleased = .{ .button = @intToEnum(sf.window.mouse.Button, event.mouseButton.button), .pos = .{ .x = event.mouseButton.x, .y = event.mouseButton.y } } },
            sf.c.sfEvtMouseMoved => .{ .mouseMoved = .{ .pos = .{ .x = event.mouseMove.x, .y = event.mouseMove.y } } },
            sf.c.sfEvtMouseEntered => .{ .mouseEntered = {} },
            sf.c.sfEvtMouseLeft => .{ .mouseLeft = {} },
            sf.c.sfEvtCount => @panic("sfEvtCount should't exist as an event!"),
            else => @panic("Unknown event!"),
        };
    }

    /// Gets how many types of event exist
    pub fn getEventCount() c_uint {
        return @enumToInt(sf.c.sfEventType.sfEvtCount);
    }

    /// Size events parameters
    pub const SizeEvent = struct {
        const structId: i128 = 333;
        const SELF = @This();

        size: sf.Vector2u,
        
        pub fn toInt(self: SELF) i128 {
            var uid: i128 = undefined;

            var cX = @intCast(i128, self.size.x);
            var cY = @intCast(i128, self.size.y);

            _=@addWithOverflow(i128, cX, structId, &uid);
            _=@addWithOverflow(i128, cY, structId, &uid);

            return uid;
        }
    };

    /// Keyboard event parameters
    pub const KeyEvent = struct {
        const structId: i128 = 4444;
        const SELF = @This();

        code: sf.window.keyboard.KeyCode,
        alt: bool,
        control: bool,
        shift: bool,
        system: bool,

        pub fn toInt(self: SELF) i128 {
            var uid: i128 = undefined;

            var cS: i128 = @boolToInt(self.alt) + @boolToInt(self.control) + @boolToInt(self.shift) + @boolToInt(self.system);
            var cE: i128 = @enumToInt(self.code)+594;

            _=@addWithOverflow(i128, cS, structId, &uid);
            _=@addWithOverflow(i128, cE, structId, &uid);

            return uid;
        }

    };

    /// Text event parameters
    pub const TextEvent = struct {
        const structId: i128 = 55555;
        const SELF = @This();
        unicode: u32,

        pub fn toInt(self: SELF) i128 {
            var uid: i128 = undefined;

            _=@addWithOverflow(i128, self.unicode*54, structId, &uid);

            return uid;
        }
    };

    /// Mouse move event parameters
    pub const MouseMoveEvent = struct {
        const structId: i128 = 666666;
        const SELF = @This();
        pos: sf.Vector2i,

        pub fn toInt(self: SELF) i128 {
            var uid: i128 = undefined;

            var cX = @intCast(i128, self.pos.x);
            var cY = @intCast(i128, self.pos.y);

            _=@addWithOverflow(i128, cX, 0, &uid);
            _=@mulWithOverflow(i128, cY, uid, &uid);
            _=@mulWithOverflow(i128, structId, uid, &uid);

            return uid;
        }

    };

    /// Mouse buttons events parameters
    pub const MouseButtonEvent = struct {
        const structId: i128 = 7777777;
        const SELF = @This();

        button: sf.window.mouse.Button,
        pos: sf.Vector2i,
        
        pub fn toInt(self: SELF) i128 {
            var uid: i128 = undefined;

            var cX = @intCast(i128, self.pos.x);
            var cY = @intCast(i128, self.pos.y);
            var cBut = @enumToInt(self.button)+425;
            _=@addWithOverflow(i128, cX, structId, &uid);
            _=@addWithOverflow(i128, cY, structId, &uid);
            _=@addWithOverflow(i128, cBut, structId, &uid);

            return uid;
        }
    };

    /// Mouse wheel events parameters
    pub const MouseWheelScrollEvent = struct {
        const SELF = @This();
        const structId: i128 = 88888888;

        wheel: sf.window.mouse.Wheel,
        delta: f32, // f32
        pos: sf.Vector2i,

        pub fn toInt(self: SELF) i128 {
            var uid: i128 = undefined;

            var cDelta = @floatToInt(i128, @round(self.delta * 853422465.53));
            var cX = @intCast(i128, self.pos.x);
            var cY = @intCast(i128, self.pos.y);
            var cWheel: i128 = @intCast(i128, @enumToInt(self.wheel)+53); 

            _=@addWithOverflow(i128, cDelta, structId, &uid);
            _=@addWithOverflow(i128, cX, structId, &uid);
            _=@addWithOverflow(i128, cY, structId, &uid);
            _=@addWithOverflow(i128, cWheel, structId, &uid);

            return uid;
        }

    };

    pub fn toInt(self: Self) i128 {
        return switch (self) {
            Event.closed => 550002,
            Event.resized => self.resized.toInt(),
            Event.lostFocus=> 550003,
            Event.gainedFocus => 550004,
            Event.textEntered => self.textEntered.toInt(),
            Event.keyPressed => self.keyPressed.toInt(),
            Event.keyReleased => self.keyReleased.toInt(),
            Event.mouseButtonPressed => self.mouseButtonPressed.toInt(),
            Event.mouseButtonReleased => self.mouseButtonReleased.toInt(),
            Event.mouseMoved => self.mouseMoved.toInt(),
            Event.mouseEntered => 550005,
            Event.mouseLeft => 550006,
            Event.mouseWheelScrolled => self.mouseWheelScrolled.toInt(),
        };
    }

    // An event is one of those
    closed: void,
    resized: SizeEvent,
    lostFocus: void,
    gainedFocus: void,
    textEntered: TextEvent,
    keyPressed: KeyEvent,
    keyReleased: KeyEvent,
    mouseWheelScrolled: MouseWheelScrollEvent,
    mouseButtonPressed: MouseButtonEvent,
    mouseButtonReleased: MouseButtonEvent,
    mouseMoved: MouseMoveEvent,
    mouseEntered: void,
    mouseLeft: void,
};