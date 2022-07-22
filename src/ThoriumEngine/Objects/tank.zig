const sf = @import("sf");
const Self = @This();
const print = @import("std").debug.print;
const math = @import("std").math;

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
    turretSprite.setOrigin(sf.Vector2f.new(12, 37));

    sprite.setPosition(pos);

    turretSprite.setPosition(pos);
    
    return Self{ 
        .sprite = sprite, 
        .texture = texture,
        .position = pos,
        .turretTexture = turretTexture,
        .turretSprite = turretSprite,
        .turretAngle = 90,
        .angle = 90,
        .speed = 8,

    };
}

pub fn rotate(self: *Self, angle: f32) void {
    // rotate tank with turret
    self.angle += angle;
    self.turretAngle += angle;
    self.sprite.rotate(angle);
    self.turretSprite.rotate(angle);
}

pub fn rotateTurret(self: *Self, angle: f32) void {
    // rotate only turret
    self.turretAngle += angle;
    self.turretSprite.rotate(angle);
}

pub fn gas(self: *Self, direction: f32) void {
    // direction must be `-1.0` or `1.0`
    const xOffset: f32 = - @intToFloat(f32, self.speed) * math.cos(self.angle * math.pi / 180.0);
    const yOffset: f32 = - @intToFloat(f32, self.speed) * math.sin(self.angle * math.pi / 180.0);
    self.sprite.move(sf.Vector2f.new(xOffset * direction, yOffset * direction));
    self.turretSprite.move(sf.Vector2f.new(xOffset * direction, yOffset * direction));
}

sprite: sf.Sprite,
turretSprite: sf.Sprite,
texture: sf.Texture,
turretTexture: sf.Texture,
position: sf.Vector2f,
turretAngle: f32,
angle: f32,
speed: i32,