const gameEvent = union(enum) {
    
    pub const buttonEvent = struct {
        id: i64
    };

    buttonPressed: buttonEvent
};