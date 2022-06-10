const sf = @import("sf");
const Self = @This();
const print = @import("std").debug.print;

pub fn destroy(self: *Self) void {
    self.sprite.destroy();
    self.texture.destroy();
}

pub fn drawOnWindow(self: *Self, window: *sf.RenderWindow) void {
    window.draw(self.sprite, null);
    window.draw(self.turretSprite, null);
}

pub fn create() !Self {
    var texture = try sf.Texture.createFromFile("./resources/tank.png");
    var turretTexture = try sf.Texture.createFromFile("./resources/turret.png");
    var sprite = try sf.Sprite.createFromTexture(texture);
    var turretSprite = try sf.Sprite.createFromTexture(turretTexture);
    
    var pos = sf.Vector2f.new(500, 350);
    
    sprite.setOrigin(sf.Vector2f.new(22, 40));
    sprite.setPosition(pos);

    turretSprite.setPosition(pos);
    
    return Self{ 
        .sprite = sprite, 
        .texture = texture,
        .position = pos,
        .turretTexture = turretTexture,
        .turretSprite = turretSprite 
    };
}

sprite: sf.Sprite,
turretSprite: sf.Sprite,
texture: sf.Texture,
turretTexture: sf.Texture,
position: sf.Vector2f
