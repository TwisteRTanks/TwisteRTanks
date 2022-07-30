const std = @import("std");
pub const gameEvent = union(enum) {
    
    const SELF = @This();

    pub const buttonEvent = struct {
        const Self = @This();
        const structId: i128 = -1;

        id: u64,

        pub fn toStr(self: Self) ![250]u8 {
            var buf: [250]u8 = undefined;
            _ = try std.fmt.bufPrint(&buf, "{s}", .{self});
            return buf;
        }
    };
    
    pub fn toStr(self: SELF) ![250]u8 {
        return switch (self){ 
            gameEvent.buttonPressed => try self.buttonPressed.toStr(),
        };
    }

    pub fn getEventName(self: gameEvent) []const u8 {
        return switch (self) {
            gameEvent.buttonPressed => "gameEvent.buttonPressed",
        };
    }

    buttonPressed: buttonEvent
};