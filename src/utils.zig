const std = @import("std");
const Allocator = std.mem.Allocator;
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

pub fn removeValFromArrayU8(array: []u8, value: u8) ![]u8 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    
    var countOfRemovingValues: u64 = 0;
    
    for (array) |i| {
        if (i == value) {
            countOfRemovingValues += 1;
        }
    }

    const newArrayLen: u64 = array.len - countOfRemovingValues;
    const newArray = try allocator.alloc(u8, newArrayLen);
    std.debug.print("array: {}", .{newArray[0..newArrayLen].*});
    return newArray;

}