# TwisteRTanks
Notice: now game compiling only for x86-64, x64 platforms. On Arm platforms game not working correctly.

Issue posted by @linux-admin0001 in https://github.com/Guigui220D/zig-sfml-wrapper/issues/38#issuecomment-1166596534_

TODO-LIST:

* Write recource manager
* Write renderer manager
* Write UID manager
* Write config parser for gui configs
Resource manager:
* Must contain resources which stored in memory long time (buttons, menus, others)

Gui config file example:
```json5
{
    "Root-Elements": {
        "Root-Menu": {
            "rstates": ["inMainMenu"],
            "labels": [
                {
                    "title": "base",
                    "posx": 0,
                    "posy": 0,
                    "color": "0xCOFFEE",
                    "pxsize:": 15
                },
            ],

            "buttons": [],
        },

        "Buttons": [
            // does not have `rstates` field
            {
                "rstates": ["inMainMenu", "Playing", "Paused"],
                "title": "Close",
                "posx": 0,
                "posy": 0,
                "color": "0x00FF00",
                "pxsize": 15
            },
        ],

        "inputFields": [
            {
                "text": "enter your nick", 
                "rstates": ["inMainMenu", "Playing", "Paused"],
                "showText": true,
                "posx": 0,
                "posy": 0,
                "pxsize": 15,
            }
        ],

        "PauseMenu:": {},
        "canvases": {
            "transparency": 100,
            "posx": 0,
            "posy": 0,
            "w": 100,
            "h": 100
        }
    }
}
```

Game states: Playing, Paused, inMainMenu
Menu states: inChoosingTank, inSettings
