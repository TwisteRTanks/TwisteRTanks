const sf = @import("sf");

pub const Handler = struct {
    const Self = @This();

    window: *sf.RenderWindow,

    pub fn create(window: *sf.RenderWindow) Self {
        return Self{ .window = window };
    }

    pub fn register(event: sf.window.Event) void {
        _ = event;
    }

    pub fn update(self: *Self) void {
        while (self.window.pollEvent()) |event| {
            switch (event) {
                .closed => self.window.close(),
                .keyReleased => |kev| {
                    if (kev.code == sf.keyboard.KeyCode.Space) {
                        // pausing
                    }
                },
                else => {},
            }
        }
    }
};
