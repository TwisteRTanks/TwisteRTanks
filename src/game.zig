const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
// const Handler = @import("handlers/winevents.zig").Handler;
const sf = @import("sf.zig");
const print = @import("std").debug.print;

pub fn mainloop() !void {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    // var handler = Handler.create(&window);
    var tank = try Tank.create();

    errdefer window.destroy();
    defer tank.destroy();

    while (window.isOpen()) {
        // handler.update();
        while (window.pollEvent()) |event| {
            switch (event) {
                .closed => window.close(),
                .keyReleased => |kev| {
                    if (kev.code == sf.keyboard.KeyCode.Space) {
                        // pausing
                    }
                },
                else => {},
            }
        }
        window.clear(sf.Color.Black);
        tank.drawOnWindow(&window);
        window.display();
    }
}
