const sf = @import("sf");
const getRandNumInRan = @import("../utils.zig").genRandNumInRange;
const math = @import("math");

pub const Button = struct {

    const Self = @This();

    id: i64,
    isPressed: bool,
    position: sf.Vector2f,
    bgColor: sf.Color = sf.Color.Black,
    textColor: sf.Color = sf.Color.White,
    text: sf.Text,
    body: sf.RectangleShape,

    pub fn create(pos: [2]f32, tlabel: [:0]const u8) !Self {
        var text = try sf.Text.createWithText(
                tlabel, 
                try sf.Font.createFromFile(
                    "./resources/sansation.ttf"
                ),
                64
        );

        var body = try sf.RectangleShape.create(
            sf.Vector2f.new(
                text.getLocalBounds().width+40,
                text.getLocalBounds().height+20
            )
        );
        text.setPosition(sf.Vector2f.new(pos[0], pos[1]));
        body.setFillColor(sf.Color.fromRGB(30, 30, 30));
        body.setPosition(sf.Vector2f.new(text.getGlobalBounds().left-20, text.getGlobalBounds().top-10));
        

        return Self {
            .id = 0,//genRandNumInRange(math.minInt(i32), math.maxInt(i32)),
            .isPressed = false,
            .position = sf.Vector2f.new(pos[0], pos[1]),
            .text = text,
            .body = body
        };
    }

    pub fn update(self: *Self, window: sf.RenderWindow) void {

        var pos: sf.Vector2i = sf.window.mouse.getPosition(window);
        var fposx: f32 = @intToFloat(f32, pos.x);
        var fposy: f32 = @intToFloat(f32, pos.y);
        var fpos: sf.Vector2f = sf.Vector2f.new(fposx, fposy);

        if (self.body.getGlobalBounds().contains(fpos)) {
            self.body.setFillColor(sf.Color.Black);
        } else {
            self.body.setFillColor(sf.Color.fromRGB(30, 30, 30));
        }
    }

    pub fn drawOnWindow(self: Self, window: *sf.RenderWindow) void {
        window.draw(self.body, null);
        window.draw(self.text, null);
    }

};