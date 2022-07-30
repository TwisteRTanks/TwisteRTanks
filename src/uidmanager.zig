const std = @import("std");
const Self = @This();

pub fn create() Self {
    return Self {
        .i = 0,
    };
}

pub fn getUID(self: *Self) u64 {
    self.i += 1;
    return self.i - 1;
}

i: u64,

test "Testing UIDManager values" {
    var uidm = Self.create();
    try std.testing.expectEqual(@as(u64, 0), uidm.getUID());
    try std.testing.expectEqual(@as(u64, 1), uidm.getUID());
    try std.testing.expectEqual(@as(u64, 2), uidm.getUID());
}