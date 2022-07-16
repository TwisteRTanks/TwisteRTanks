pub const gameEvent = union(enum) {
    
    pub const buttonEvent = struct {
        const Self = @This();

        const structId: i128 = -1;

        id: i64,

        pub fn toInt(self: Self) i128 {
            var uid: i128 = undefined;
            _=@mulWithOverflow(i128, @intCast(i128, self.id), structId, &uid);
            return uid;
        }

    };

    pub fn toInt(self: gameEvent) i128 {
        return switch (self) {
            gameEvent.buttonPressed => self.buttonPressed.toInt(),
        };
    }

    buttonPressed: buttonEvent
};