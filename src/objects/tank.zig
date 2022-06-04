const sf = @import("../sf.zig").sf;
const print = @import("std").debug.print;
const Self = @This();

pub fn destroy(self: *Self) void {
    self.sprite.destroy();
    self.texture.destroy();

}

pub fn create() !Self {
    
    var texture = try sf.Texture.createFromFile("./resources/tank.png");
    
    var sprite = try sf.Sprite.createFromTexture(texture);
    
    return Self{.sprite = sprite};
}
sprite: sf.Sprite