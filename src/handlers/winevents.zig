const sf = @import("sf");

const Handler = struct {
    const Self = @This();

    window: *sf.RenderWindow,

    pub fn create(window: *sf.RenderWindow) Self {
        return Self{ .window = window };
    }
    pub fn update(self: *Self) void {
        while (window.pollEvent()) |event| {
            switch (event) {
                .closed => window.close(),
                .keyReleased => |kev| {
                    if (kev.code == sf.keyboard.KeyCode.Space)
                        pause = !pause;
                },
                else => {},
            }
        }
    }
};
