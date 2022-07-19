const Game = @import("game.zig");

// Generic signature: fn(*Game) anyerror! void

pub fn onCloseWindow(game: *Game) anyerror!void {
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