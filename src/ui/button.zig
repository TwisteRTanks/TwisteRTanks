const sf = @import("sf");
const genRandNumInRange = @import("../utils.zig").genRandNumInRange;
const math = @import("std").math;
const EventWrapper = @import("../core/eventWrapper.zig").EventWrapper;
const EventManager = @import("../core/evmanager.zig");

pub const Button = struct {

    const Self = @This();

    id: i64,
    isPressed: bool,
    position: sf.Vector2f,
    bgColor: sf.Color = sf.Color.Black,
    textColor: sf.Color = sf.Color.White,
    text: sf.Text,
    body: sf.RectangleShape,
    supplier: *sf.RenderWindow,
    eventManager: EventManager,

    pub fn create(pos: [2]f32, tlabel: [:0]const u8, supplier: *sf.RenderWindow, evmanager: EventManager) !Self {
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
            .id = 0, //genRandNumInRange(math.minInt(i32), math.maxInt(i32)),
            .isPressed = false,
            .position = sf.Vector2f.new(pos[0], pos[1]),
            .text = text,
            .body = body,
            .supplier = supplier,
            .eventManager = evmanager,
        };
    }

    pub fn update(self: *Self) void {

        var pos: sf.Vector2i = sf.window.mouse.getPosition(self.supplier.*);
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
        //var window: *sf.RenderWindow = self.supplier;
        window.draw(self.body, null);
        window.draw(self.text, null);
    }

    // This function doing anything
    pub fn checkIsClicked(self: Self, event: EventWrapper) bool {
        _=self; _=event;
        //std.debug.print("{s}", .{event});
        return true;
    }

};