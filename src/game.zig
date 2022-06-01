const utils = @import("utils.zig");

pub fn mainloop() !void {
    var window = try utils.create_window(200, 200, "TwisteRTanks");
    errdefer window.destroy();
    while (true){
        window.display();
    }
}