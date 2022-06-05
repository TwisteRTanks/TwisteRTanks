const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const Handler = @import("handlers/winevents.zig").Handler;
const sf = @import("sf");

pub fn mainloop() !void {
    var window = try utils.create_window(200, 200, "TwisteRTanks");
    var handler = Handler.create(&window);
    var tank = try Tank.create();

    errdefer window.destroy();
    defer tank.destroy();

    while (window.isOpen()) {
        handler.update();
        window.clear(sf.Color.Black);
        window.draw(tank.sprite, null);
        window.display();
    }
}
