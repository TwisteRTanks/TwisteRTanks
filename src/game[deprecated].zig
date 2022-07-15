const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const Map = @import("map.zig");
const Button = @import("ui/button.zig").Button;
// const Handler = @import("handlers/winevents.zig").Handler;
const sf = @import("sf.zig");
const keyboard = sf.window.keyboard;
const print = @import("std").debug.print;

pub fn mainloop() !void {
    var window = try utils.create_window(1000, 700, "TwisteRTanks");
    window.setFramerateLimit(60);
    
    var map = Map.create();
    try map.genMap();
    try map.drawOnWindow(&window);

    var button = try Button.create(.{400, 300}, "Button");

    print("NOTICE:\n", .{});
    print("Use W/S keys for rotate turret and Left/Right for rotate tank\n", .{});
    print("Up/Down for moving tank\n", .{});

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

        // ----------- Keyboard handling -----------
        {
            if (keyboard.isKeyPressed(keyboard.KeyCode.Down)) {
                tank.gas(-1);
            }
            if (keyboard.isKeyPressed(keyboard.KeyCode.Up)) {
                tank.gas(1);
            }
            if (keyboard.isKeyPressed(keyboard.KeyCode.Left)) {
                tank.rotate(-1);
            }
            if (keyboard.isKeyPressed(keyboard.KeyCode.Right)) {
                tank.rotate(1);
            }
            if (keyboard.isKeyPressed(keyboard.KeyCode.W)) {
                tank.rotateTurret(1);
            }
            if (keyboard.isKeyPressed(keyboard.KeyCode.S)) {
                tank.rotateTurret(-1);
            }
        }
        // ----------- Keyboard handling -----------

        window.clear(sf.Color.Black);
        try map.drawOnWindow(&window);
        tank.drawOnWindow(&window);
        button.update(window);
        button.drawOnWindow(&window);
        window.display();
    }
}
