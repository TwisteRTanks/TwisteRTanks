// Scene must contain each kind of elements
const std = @import("std");
const Self = @This();
const sf = @import("sf");

const Button = @import("button.zig").Button;
const InputField = @import("inputField.zig");
const Label = @import("label.zig");
const Menu = @import("menu.zig");

pub fn create() !Self {
    return Self {
        .buttons = std.ArrayList(*Button).init(std.heap.page_allocator),
        .labels = std.ArrayList(*Label).init(std.heap.page_allocator),
        .inputFields = std.ArrayList(*InputField).init(std.heap.page_allocator),
        .menus = std.ArrayList(*Menu).init(std.heap.page_allocator),
    };
}

pub fn destroy(self: *Self) void {
    _=self;
}

fn addButton(self: *Self, button: Button) !void {
    const ptr = try std.heap.page_allocator.create(Button);
    ptr.* = button;
    try self.buttons.append(ptr);
}

fn addLabel(self: *Self, label: Label) !void {
    const ptr = try std.heap.page_allocator.create(Label);
    ptr.* = label;
    try self.labels.append(ptr);
}

fn addInputField(self: *Self, inpField: InputField) void {
    const ptr = try std.heap.page_allocator.create(InputField);
    ptr.* = inpField;
    try self.inputFields.append(ptr);
}

fn addMenu(self: *Self, menu: *Menu) void {
    const ptr = try std.heap.page_allocator.create(menu);
    ptr.* = menu;
    try self.menus.append(ptr);
}

// Element must be known at comp time
pub fn addElement(self: *Self, element: anytype) !void {
    switch (@TypeOf(element)) {
        Button => self.addButton(element),
        Label => self.addLabel(element),
        InputField => self.addInputField(element),
        Menu => self.addMenu(element),
        else => {@panic("Incorrect element");}
    }
}

pub fn drawOnWindow(self: *Self, window: *sf.RenderWindow) void {
    for (self.buttons.items) |ptr| {
        ptr.*.drawOnWindow(window);
    }
    for (self.menu.items) |ptr| {
        ptr.*.drawOnWindow(window);
    }
}

pub fn update(self: *Self) void {
    for (self.buttons.items) |ptr| {
        ptr.*.update();
    }

    // for (self.labels.items) |ptr| {
    //     ptr.update();
    // }

    // for (self.inputFields.items) |ptr| {
    //     ptr.update();
    // }

    for (self.menus.items) |ptr| {
        ptr.*.update();
    }

}

buttons: std.ArrayList(*Button),
labels: std.ArrayList(*Label),
inputFields: std.ArrayList(*InputField),
menus: std.ArrayList(*Menu),