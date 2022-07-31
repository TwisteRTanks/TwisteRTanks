const sf = @import("sf");
const genRandNumInRange = @import("../utils.zig").genRandNumInRange;
const math = @import("std").math;
const EventWrapper = @import("../core/eventWrapper.zig").EventWrapper;
const gameEvent = @import("../core/gameEvent.zig").gameEvent;
const EventManager = @import("../core/evmanager.zig");
const UIDManager = @import("../uidmanager.zig");
const std = @import("std");

pub const Button = struct {

    const Self = @This();

    id: u64,
    position: sf.Vector2f,
    bgColor: sf.Color = sf.Color.Black,
    textColor: sf.Color = sf.Color.White,
    text: sf.Text,
    body: sf.RectangleShape,
    supplier: *sf.RenderWindow,
    eventManager: *EventManager,
    clock: sf.Clock,
    isPressed: bool,

    pub fn destroy(self: *Self) void {
        self.text.destroy();
        self.body.destroy();
        self.clock.destroy();
    }
    ///
    pub fn create(
        pos: [2]f32, 
        tlabel: [:0]const u8, 
        supplier: *sf.RenderWindow, 
        evmanager: *EventManager, 
        uidm: *UIDManager,
        bodysize: ?sf.Vector2f
    ) !Self {

        const xPos: f32 = pos[0];
        const yPos: f32 = pos[1]; 

        var text = try sf.Text.createWithText(
                tlabel, 
                try sf.Font.createFromFile(
                    "./resources/sansation.ttf"
                ),
                64
        );

        var body: sf.RectangleShape = undefined; 

        if (bodysize == null) {
            body = try sf.RectangleShape.create(
                sf.Vector2f.new(
                    text.getLocalBounds().width+40,
                    text.getLocalBounds().height+20
                )
            );
        } else {
            body = try sf.RectangleShape.create(bodysize.?);
        }

        const localBodyBounds: sf.FloatRect = body.getLocalBounds();
        const localTextBounds: sf.FloatRect = text.getLocalBounds();

        const bodyW: f32 = localBodyBounds.width;
        const textW: f32 = localTextBounds.width;

        const bodyH: f32 = localBodyBounds.height;
        const textH: f32 = localTextBounds.height;

        const yInaccuracy: f32 = 18.5;
        const textOffsetX: f32 = (bodyW-textW) / 2.0;
        const textOffsetY: f32 = ((bodyH-textH) / 2.0) - yInaccuracy;

        body.setPosition(sf.Vector2f.new(xPos, yPos));
        text.setPosition(sf.Vector2f.new(xPos + textOffsetX, yPos + textOffsetY));
        body.setFillColor(sf.Color.fromRGB(0, 0, 0));

        return Self {
            .id = uidm.getUID(),
            .isPressed = false,
            .position = sf.Vector2f.new(pos[0], pos[1]),
            .text = text,
            .body = body,
            .supplier = supplier,
            .eventManager = evmanager,
            .clock = try sf.Clock.create(),
        };
    }

    pub fn update(self: *Self) void {
        if ((self.isPressed == true ) and (self.clock.getElapsedTime().asSeconds() > 0.3)) {
            self.isPressed = false;
            self.body.setFillColor(sf.Color.fromRGB(0, 0, 0));
        }
    }

    pub fn setPosition(self: *Self, pos: [2]f32) void {
        self.text.setPosition(sf.Vector2f.new(pos[0]+20, pos[1]+10));
        self.body.setPosition(sf.Vector2f.new(self.text.getGlobalBounds().left, self.text.getGlobalBounds().top));
    }

    pub fn drawOnWindow(self: Self, window: *sf.RenderWindow) void {
        window.draw(self.body, null);
        window.draw(self.text, null);
    }

    // This function doing anything
    pub fn checkIsClicked(self: *Self, event: EventWrapper) !bool {
        var pos: sf.Vector2i = event.sfmlEvent.mouseButtonPressed.pos;
        var fposx: f32 = @intToFloat(f32, pos.x);
        var fposy: f32 = @intToFloat(f32, pos.y);
        var fpos: sf.Vector2f = sf.Vector2f.new(fposx, fposy);

        if ((self.isPressed == false) and (self.body.getGlobalBounds().contains(fpos))) {
            self.isPressed = true;
            self.body.setFillColor(sf.Color.fromRGB(70, 70, 70));
            _=self.clock.restart();
            try self.eventManager.putGameEvent(
                gameEvent{
                    .buttonPressed = .{
                        .id = self.id
                    }
                }
            ); 
            return true;
        }        
        return false;
    }

};