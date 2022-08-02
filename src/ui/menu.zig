const Self = @This();
const std = @import("std");
const sf = @import("sf");

const Button = @import("button.zig").Button;
const InputField = @import("inputField.zig");
const Label = @import("label.zig");
const Menu = @import("menu.zig");
const Game = @import("../game.zig");

const MenuStyle = enum(c_int) {
    Horizontal,
    Vertical
};

pub fn create(game: *Game, title: [:0]const u8, pos: sf.Vector2f) !Self {
    var text = try sf.Text.createWithText(
            title, 
            try sf.Font.createFromFile(
                "./resources/sansation.ttf"
            ),
            64
    );
    text.setPosition(pos);
    text.setFillColor(sf.Color.fromRGB(255, 215, 0));

    return Self{
        .game = game,
        .title = text,
        .buttons = std.ArrayList(*Button).init(std.heap.page_allocator),
        .position = pos,
        .width = text.getLocalBounds().width,
    };
}

pub fn destroy(self: *Self) void {
    self.title.destroy();
    
    for (self.buttons.items) |buttonPtr| {
        std.heap.page_allocator.destroy(buttonPtr);
    }
}

/// The `button` parameter accepts a button with **relative** coordinates
pub fn addButton(self: *Self, label: [:0]const u8) !void {

    const topButton: ?*Button = self.buttons.popOrNull();
    
    // TODO: refactor this code
    if (topButton != null) {
        try self.buttons.append(topButton.?);
    }

    var topButtonCords: sf.Vector2f = undefined;
    var height: f32 = 0;
    if (topButton == null){
        topButtonCords = sf.Vector2f.new(0, 70);
    } else {
        topButtonCords = topButton.?.position;
        height = topButton.?.body.getLocalBounds().height;
    }

    const tbcY: f32 = topButtonCords.y + height + 5;

    const tbPos: [2]f32 = .{self.position.x, tbcY + self.position.y};
    
    // Now button have absolute position
    var button: Button = try Button.create(self.game, tbPos, label, sf.Vector2f.new(self.width, 70));

    const buttonPtr = try std.heap.page_allocator.create(Button);
    buttonPtr.* = button;
    try self.buttons.append(buttonPtr);
}

pub fn drawOnWindow(self: *Self, window: *sf.RenderWindow) void {
    window.draw(self.title, null);
    for (self.buttons.items) |buttonPtr| {
        buttonPtr.*.drawOnWindow(window);
    }
}

pub fn update(self: *Self) void {
    for (self.buttons.items) |buttonPtr| {
        buttonPtr.*.update();
    }
}

game: *Game,
title: sf.Text,
buttons: std.ArrayList(*Button),
position: sf.Vector2f,
width: f32 = 200,
//supplier: sf.RenderWindow,