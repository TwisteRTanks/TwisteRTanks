const sf = @import("sf");
const Self = @This();

pub fn destroy(self: *Self) void {
    self.sprite.destroy();
    self.texture.destroy();
}

pub fn create(x: f32, y: f32) !Self {
    var texture = try sf.Texture.createFromFile("resources/metal.png");
    var sprite = try sf.Sprite.createFromTexture(texture);
    sprite.setPosition(sf.Vector2f.new(x, y));
    return Self {
        .position = sf.Vector2f.new(x, y),
        .texture = texture,
        .sprite = sprite
    };
}

pub fn drawOnWindow(self: Self, window: *sf.RenderWindow) void {
    window.draw(self.sprite, null);
}

position: sf.Vector2f,
texture: sf.Texture,
sprite: sf.Sprite