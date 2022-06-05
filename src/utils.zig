const std = @import("std");

const sf = @import("sf.zig");

pub fn create_window(x: u32, y: u32, title: [:0]const u8) !sf.RenderWindow {
    var window: sf.RenderWindow = try sf.RenderWindow.createDefault(.{ .x = x, .y = y }, title);
    return window;
}
