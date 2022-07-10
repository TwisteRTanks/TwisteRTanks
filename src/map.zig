const Self = @This();
const std = @import("std");
const print = @import("std").debug.print;
const RndGen = std.rand.DefaultPrng;
const randImpl = RndGen.init(@intCast(u64, std.time.milliTimestamp()));

const sf = @import("sf");
const Tile = @import("tile.zig");
const range = @import("range.zig").range;

pub fn destroy() void {
}

pub fn create() Self {    
    return Self {
        .tiles = undefined,
    };
}

pub fn genNumInRange(a: i32, b: i64) i32 { 
    return randImpl.random().intRangeLessThan(i32, a, b);
}

pub fn genMap(self: *Self) !void {   
    var i: u32 = 0;
    for (range(16)) |_, x| {
        for (range(11)) |_, y| {
            self.tiles[i] = try Tile.create(@intToFloat(f32, x) * 64, @intToFloat(f32, y) * 64);
            i+=1;
        }
    }
}

pub fn drawOnWindow(self: Self, window: *sf.RenderWindow) !void {
    for (self.tiles) |tile| {
        tile.drawOnWindow(window);
    }
}
tiles: [176]Tile,
