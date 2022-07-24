const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
};

const std = @import("std");

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
        const This = @This();

        size: sf.Vector2u,
        
        pub fn toStr(self: This) ![250]u8 {
            var buf: [250]u8 = undefined;
            _ = try std.fmt.bufPrint(&buf, "{s}", .{self});
            return buf;
        }
    };

    /// Keyboard event parameters
    pub const KeyEvent = struct {
        const This = @This();

        code: sf.window.keyboard.KeyCode,
        alt: bool,
        control: bool,
        shift: bool,
        system: bool,

        pub fn toStr(self: This) ![250]u8 {
            var buf: [250]u8 = undefined;
            _ = try std.fmt.bufPrint(&buf, "{s}", .{self});
            return buf;
        }
    };

    /// Text event parameters
    pub const TextEvent = struct {
        const This = @This();
        unicode: u32,

        pub fn toStr(self: This) ![250]u8 {
            var buf: [250]u8 = undefined;
            _ = try std.fmt.bufPrint(buf, "{s}", .{self});
            return buf;
        }
    };

    /// Mouse move event parameters
    pub const MouseMoveEvent = struct {
        const This = @This();
        pos: sf.Vector2i,

        pub fn toStr(self: This) ![250]u8 {
            var buf: [250]u8 = undefined;
            //for (buf[0..250]) |*b| b.* = 32;
            _ = try std.fmt.bufPrint(&buf, "{s}", .{self});
            return buf;
        }
    };

    /// Mouse buttons events parameters
    pub const MouseButtonEvent = struct {
        const This = @This();

        button: sf.window.mouse.Button,
        pos: sf.Vector2i,
        
        pub fn toStr(self: This) ![250]u8 {
            var buf: [250]u8 = undefined;
            _ = try std.fmt.bufPrint(&buf, "{s}", .{self});
            return buf;
        }
    };

    /// Mouse wheel events parameters
    pub const MouseWheelScrollEvent = struct {
        const This = @This();

        wheel: sf.window.mouse.Wheel,
        delta: f32, // f32
        pos: sf.Vector2i,

        pub fn toStr(self: This) ![250]u8 {
            var buf: [250]u8 = undefined;
            _ = try std.fmt.bufPrint(&buf, "{s}", .{self});
            return buf;
        }
    };

    pub fn toStr(self: Self) ![250]u8 {
        return switch (self){
            Event.closed => {
                var array: [250]u8 = undefined;
                std.mem.copy(u8, &array, ("Event.closed".*)[0..12]);
                return array;
            },
            Event.resized => try self.resized.toStr(),
            Event.lostFocus=> {
                var array: [250]u8 = undefined;
                std.mem.copy(u8, &array, ("Event.lostFocus".*)[0..15]);
                return array;
            },
            Event.gainedFocus => {
                var array: [250]u8 = undefined;
                std.mem.copy(u8, &array, ("Event.gainedFocus".*)[0..17]);
                return array;
            },
            Event.textEntered => {
                var array: [250]u8 = undefined;
                std.mem.copy(u8, &array, ("Event.textEntered".*)[0..17]);
                return array;
            },
            Event.keyPressed => try self.keyPressed.toStr(),
            Event.keyReleased => try self.keyReleased.toStr(),
            Event.mouseButtonPressed => try self.mouseButtonPressed.toStr(),
            Event.mouseButtonReleased => try self.mouseButtonReleased.toStr(),
            Event.mouseMoved => try self.mouseMoved.toStr(),
            Event.mouseEntered => {
                var array: [250]u8 = undefined;
                std.mem.copy(u8, &array, ("Event.mouseEntered".*)[0..18]);
                return array;
            },
            Event.mouseLeft => {
                var array: [250]u8 = undefined;
                std.mem.copy(u8, &array, ("Event.mouseLeft".*)[0..15]);
                return array;
            },
            Event.mouseWheelScrolled => try self.mouseWheelScrolled.toStr(),
        };
    }

    pub fn getEventName(self: Self) []const u8 {
        return switch (self){
            Event.closed => "Event.closed",
            Event.resized => "Event.resized",
            Event.lostFocus=> "Event.lostFocus",
            Event.gainedFocus => "Event.gainedFocus",
            Event.textEntered => "Event.textEntered",
            Event.keyPressed => "Event.keyPressed",
            Event.keyReleased => "Event.keyReleased",
            Event.mouseButtonPressed => "Event.mouseButtonPressed",
            Event.mouseButtonReleased => "Event.mouseButtonReleased",
            Event.mouseMoved => "Event.mouseMoved",
            Event.mouseEntered => "Event.mouseEntered",
            Event.mouseLeft => "Event.mouseLeft",
            Event.mouseWheelScrolled => "Event.mouseWheelScrolled",
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