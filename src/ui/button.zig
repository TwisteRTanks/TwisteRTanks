const sf = @import("sf");

pub const Button = struct {

    const Self = @This();

    isPressed: bool,
    position: sf.Vector2f,
    bgColor: sf.Color = sf.Color.Black,
    textColor: sf.Color = sf.Color.White,
    text: sf.Text,

    pub fn create(pos: [2]f32, tlabel: [:0]const u8) !Self {
        return Self {
            .isPressed = false,
            .position = sf.Vector2f.new(pos[0], pos[1]),
            .text = try sf.Text.createWithText(
                tlabel, 
                try sf.Font.createFromFile(
                    "./resources/sansation.ttf"
                ),
                16
            ),
        };
    }

    pub fn drawOnWindow(self: Self, window: *sf.RenderWindow) void {
        //window.draw(self);
        _=self;
        _=window;
    }

};