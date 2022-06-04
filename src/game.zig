const utils = @import("utils.zig");
const Tank = @import("objects/tank.zig");
const sf = @import("sf.zig").sf;

pub fn mainloop() !void {
    var window = try utils.create_window(200, 200, "TwisteRTanks");
    var tank = try Tank.create();  

    errdefer window.destroy();
    defer tank.destroy();
    
    while (true){
        window.clear(sf.Color.Black);
        window.draw(tank.sprite, null);
        window.display();
        
    }
}