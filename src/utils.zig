const std = @import("std");
const RndGen = std.rand.DefaultPrng;
const randImpl = RndGen.init(@intCast(u64, std.time.milliTimestamp()));

const sf = @import("sf.zig");

pub fn create_window(x: u32, y: u32, title: [:0]const u8) !sf.RenderWindow {
    var window: sf.RenderWindow = try sf.RenderWindow.createDefault(.{ .x = x, .y = y }, title);
    return window;
}

pub fn genRandNumInRange(a: i32, b: i64) i32 { 
    return randImpl.random().intRangeLessThan(i32, a, b);
}