const std = @import("std");
const Allocator = std.mem.Allocator;
const RndGen = std.rand.DefaultPrng;


const sf = @import("sf.zig");

pub fn create_window(x: u32, y: u32, title: [:0]const u8) !sf.RenderWindow {
    var window: sf.RenderWindow = try sf.RenderWindow.createDefault(.{ .x = x, .y = y }, title);
    return window;
}

pub fn genRandNumInRange(a: i32, b: i32) !i32 { 
    var time: i64 = std.time.milliTimestamp();
    var randImpl: RndGen = RndGen.init(@bitCast(u64, time));
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
    return newArray;

}