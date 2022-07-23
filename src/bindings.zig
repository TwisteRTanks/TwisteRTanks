const Game = @import("game.zig");
const EventWrapper = @import("core/eventWrapper.zig").EventWrapper;

// Generic signature: fn(*Game, EventWrapper) anyerror!void 
// fn(*Game) anyerror!void for KeyboardManager 

pub fn onCloseWindow(game: *Game, event: EventWrapper) anyerror!void {
    _=event;
    game.window.close();
}

pub fn onLeftKeyPressed(game: *Game) anyerror!void {
    game.master.rotate(-1);
}

pub fn onRightKeyPressed(game: *Game) anyerror!void {
    game.master.rotate(1);
}

pub fn onUpKeyPressed(game: *Game) anyerror!void {
    game.master.gas(1);
}

pub fn onDownKeyPressed(game: *Game) anyerror!void {
    game.master.gas(-1);
}

pub fn onWKeyPressed(game: *Game) anyerror!void {
    game.master.rotateTurret(1);
}

pub fn onSKeyPressed(game: *Game) anyerror!void {
    game.master.rotateTurret(-1);
}

pub fn onMouseButtonLeftPressed(game: *Game, event: EventWrapper) anyerror!void {
    for (game.buttons) |button| {
        button.checkIsClicked(event);
    }
}