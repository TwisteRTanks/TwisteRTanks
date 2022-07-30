const Self = @This();
const std = @import("std");
const sf = @import("sf");

const Button = @import("button.zig").Button;
const InputField = @import("inputField.zig");
const Label = @import("label.zig");
const Menu = @import("menu.zig");

const MenuStyle = enum(c_int) {
    Horizontal,
    Vertical
};

pub fn create(title: [:0]const u8, pos: sf.Vector2f) !Self {
    var text = try sf.Text.createWithText(
            title, 
            try sf.Font.createFromFile(
                "./resources/sansation.ttf"
            ),
            64
    );
    return Self{
        .title = text,
        .buttons = std.ArrayList(*Button).init(std.heap.page_allocator),
        .position = pos,
    };
}

pub fn destroy(self: *Self) void {
    self.title.destroy();
    
    for (self.buttons.items) |buttonPtr| {
        std.heap.page_allocator.destroy(buttonPtr);
    }
}

/// The `button` parameter accepts a button with relative coordinates
pub fn addButton(self: *Self, button: Button) !void {

    button.setPosition(.{0,0});

    const buttonPtr = try std.heap.page_allocator.create(Button);
    buttonPtr.* = button;
    try self.buttons.append(buttonPtr);
}

pub fn drawOnWindow(self: *Self, window: *sf.RenderWindow) void {
    for (self.buttons.items) |buttonPtr| {
        buttonPtr.*.drawOnWindow(window);
    }
}

pub fn update(self: *Self) void {
    for (self.buttons.items) |buttonPtr| {
        buttonPtr.*.update();
    }
}

title: sf.Text,
buttons: std.ArrayList(*Button),
position: sf.Vector2f,
//supplier: sf.RenderWindow,