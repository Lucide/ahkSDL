; Simple Wrapper For SDL2

; hobby77

; https://wiki.libsdl.org/SDL2

; #Requires AutoHotkey v2
#DllLoad "%A_ScriptDir%\SDL2.dll"

SDL_EventType := {
    SDL_FIRSTEVENT: 0,
    SDL_QUIT: 0x100,
    /* WinRT app events */
    ; SDL_APP_TERMINATING: 0x101,
    ; SDL_APP_LOWMEMORY: 0x102,
    ; SDL_APP_WILLENTERBACKGROUND: 0x103,
    ; SDL_APP_DIDENTERBACKGROUND: 0x104,
    ; SDL_APP_WILLENTERFOREGROUND: 0x105,
    ; SDL_APP_DIDENTERFOREGROUND: 0x106,
    /* Display events */
    /* Only available in SDL 2.0.9 or higher. */
    ; SDL_DISPLAYEVENT: 0x150,
    /* Window events */
    ; SDL_WINDOWEVENT: 0x200,
    ; SDL_SYSWMEVENT: 0x201,
    /* Keyboard events */
    ; SDL_KEYDOWN: 0x300,
    ; SDL_KEYUP: 0x301,
    ; SDL_TEXTEDITING: 0x302,
    ; SDL_TEXTINPUT: 0x303,
    ; SDL_KEYMAPCHANGED: 0x304,
    /* Mouse events */
    ; SDL_MOUSEMOTION: 0x400,
    ; SDL_MOUSEBUTTONDOWN: 0x401,
    ; SDL_MOUSEBUTTONUP: 0x402,
    ; SDL_MOUSEWHEEL: 0x403,
    /* Joystick events */
    ; SDL_JOYAXISMOTION: 0x600,
    ; SDL_JOYBALLMOTION: 0x601,
    ; SDL_JOYHATMOTION: 0x602,
    ; SDL_JOYBUTTONDOWN: 0x603,
    ; SDL_JOYBUTTONUP: 0x604,
    ; SDL_JOYDEVICEADDED: 0x605,
    ; SDL_JOYDEVICEREMOVED: 0x606,
    /* Game controller events */
    SDL_CONTROLLERAXISMOTION: 0x650,
    SDL_CONTROLLERBUTTONDOWN: 0x651,
    SDL_CONTROLLERBUTTONUP: 0x652,
    SDL_CONTROLLERDEVICEADDED: 0x653,
    SDL_CONTROLLERDEVICEREMOVED: 0x654,
    SDL_CONTROLLERDEVICEREMAPPED: 0x655,
    SDL_CONTROLLER_BUTTON_INVALID: -1,
    SDL_CONTROLLER_BUTTON_A: 0,
    SDL_CONTROLLER_BUTTON_B: 1,
    SDL_CONTROLLER_BUTTON_X: 2,
    SDL_CONTROLLER_BUTTON_Y: 3,
    SDL_CONTROLLER_BUTTON_BACK: 4,
    SDL_CONTROLLER_BUTTON_GUIDE: 5,
    SDL_CONTROLLER_BUTTON_START: 6,
    SDL_CONTROLLER_BUTTON_LEFTSTICK: 7,
    SDL_CONTROLLER_BUTTON_RIGHTSTICK: 8,
    SDL_CONTROLLER_BUTTON_LEFTSHOULDER: 9,
    SDL_CONTROLLER_BUTTON_RIGHTSHOULDER: 10,
    SDL_CONTROLLER_BUTTON_DPAD_UP: 11,
    SDL_CONTROLLER_BUTTON_DPAD_DOWN: 12,
    SDL_CONTROLLER_BUTTON_DPAD_LEFT: 13,
    SDL_CONTROLLER_BUTTON_DPAD_RIGHT: 14,
    SDL_CONTROLLER_BUTTON_MISC1: 15,
    SDL_CONTROLLER_BUTTON_PADDLE1: 16,
    SDL_CONTROLLER_BUTTON_PADDLE2: 17,
    SDL_CONTROLLER_BUTTON_PADDLE3: 18,
    SDL_CONTROLLER_BUTTON_PADDLE4: 19,
    SDL_CONTROLLER_BUTTON_TOUCHPAD: 20,
    SDL_CONTROLLER_BUTTON_MAX: 21,
    /* Touch events */
    ; SDL_FINGERDOWN: 0x700,
    ; SDL_FINGERUP: 0x701,
    ; SDL_FINGERMOTION: 0x702,
    /* Gesture events */
    ; SDL_DOLLARGESTURE: 0x800,
    ; SDL_DOLLARRECORD: 0x801,
    ; SDL_MULTIGESTURE: 0x802,
    /* Clipboard events */
    ; SDL_CLIPBOARDUPDATE: 0x900,
    /* Drag and drop events */
    ; SDL_DROPFILE: 0x1000,
    /* Only available in 2.0.4 or higher. */
    ; SDL_DROPTEXT: 0x1001,
    ; SDL_DROPBEGIN: 0x1002,
    ; SDL_DROPCOMPLETE: 0x1003,
    /* Audio hotplug events */
    /* Only available in SDL 2.0.4 or higher. */
    ; SDL_AUDIODEVICEADDED: 0x1100,
    ; SDL_AUDIODEVICEREMOVED: 0x1101,
    /* Sensor events */
    /* Only available in SDL 2.0.9 or higher. */
    ; SDL_SENSORUPDATE: 0x1200,
    /* Render events */
    /* Only available in SDL 2.0.2 or higher. */
    ; SDL_RENDER_TARGETS_RESET: 0x2000,
    /* Only available in SDL 2.0.4 or higher. */
    ; SDL_RENDER_DEVICE_RESET: 0x2001,
    /* Events SDL_USEREVENT through SDL_LASTEVENT are for
    * your use, and should be allocated with
    * SDL_RegisterEvents()
    */
    SDL_USEREVENT: 0x8000,
    /* The last event, used for bouding arrays. */
    SDL_LASTEVENT: 0xFFFF
}

Class SDL2DLL {

    Class SDL_Event {
        type := ""
        cbutton := {}
        caxis := {}
        cdevice := {}

        __New(SDL_Event := "") {
            this.type := NumGet(SDL_Event, 0, "UInt")

            switch (this.type) {
                /* Controller button events */
                case SDL_EventType.SDL_CONTROLLERBUTTONDOWN, SDL_EventType.SDL_CONTROLLERBUTTONUP:
                    this.cbutton := {
                        type: NumGet(SDL_Event, 0, "UInt"),
                        timestamp: NumGet(SDL_Event, 4, "UInt"),
                        which: NumGet(SDL_Event, 8, "Int"),
                        button: NumGet(SDL_Event, 12, "Char"),
                        state: NumGet(SDL_Event, 13, "Char")
                    }

                    /* Controller axis events */
                case SDL_EventType.SDL_CONTROLLERAXISMOTION:
                    this.caxis := {
                        type: NumGet(SDL_Event, 0, "UInt"),
                        timestamp: NumGet(SDL_Event, 4, "UInt"),
                        which: NumGet(SDL_Event, 8, "Int"),
                        axis: NumGet(SDL_Event, 12, "Char"),
                        value: NumGet(SDL_Event, 16, "Short")
                    }

                    /* Controller device events */
                case SDL_EventType.SDL_CONTROLLERDEVICEADDED, SDL_EventType.SDL_CONTROLLERDEVICEREMOVED:
                    this.cdevice := {
                        type: NumGet(SDL_Event, 0, "UInt"),
                        timestamp: NumGet(SDL_Event, 4, "UInt"),
                        which: NumGet(SDL_Event, 8, "Int")
                    }
            }
        }
    }

    __New() {
        ;    if !this.LibLoad
        ;     MsgBox("Error while loading: " this.dll "`nPlease check the dll version")
    }

    /* Basic func */
    SDL_Delay(millisecond) => DllCall("SDL2.dll\SDL_Delay", "UInt", millisecond, "CDecl")

    SDL_Init(flags) => DllCall("SDL2.dll\SDL_Init", "UInt", flags, "CDecl")

    SDL_InitSubSystem(flags) => DllCall("SDL2.dll\SDL_InitSubSystem", "UInt", flags, "CDecl")

    SDL_Quit() => DllCall("SDL2.dll\SDL_Quit", "CDecl")

    SDL_SetHint(name, value) => DllCall("SDL2.dll\SDL_SetHint", "AStr", name, "AStr", value, "CDecl")

    SDL_GetHint(name) => DllCall("SDL2.dll\SDL_GetHint", "AStr", name, "CDecl AStr")

    SDL_PollEvent(event) => DllCall("SDL2.dll\SDL_PollEvent", "Ptr", event, "CDecl")

    /* Joystick func */
    SDL_JoystickEventState(state) => DllCall("SDL2.dll\SDL_JoystickEventState", "Int", state, "CDecl")

    SDL_NumJoysticks() => DllCall("SDL2.dll\SDL_NumJoysticks", "CDecl") ;~ Get Joystick num

    SDL_JoystickOpen(index) => DllCall("SDL2.dll\SDL_JoystickOpen", "Int", index, "CDecl Ptr") ;~ Get Joystick num

    SDL_JoystickClose(joystick) => DllCall("SDL2.dll\SDL_JoystickClose", "Ptr", joystick, "CDecl")

    SDL_JoystickInstanceID(joystick) => DllCall("SDL2.dll\SDL_JoystickInstanceID", "Ptr", joystick, "CDecl Ptr") ;~ Get Joystick Index Id, Start with 0

    SDL_JoystickNameForIndex(index) => DllCall("SDL2.dll\SDL_JoystickNameForIndex", "Int", index, "CDecl AStr")

    SDL_JoystickName(joystick) => DllCall("SDL2.dll\SDL_JoystickName", "Ptr", joystick, "CDecl AStr") ;~ Get Joystick name from JoystickOpen

    SDL_IsGameController(index) => DllCall("SDL2.dll\SDL_IsGameController", "Ptr", index, "CDecl")

    SDL_GameControllerOpen(index) => DllCall("SDL2.dll\SDL_GameControllerOpen", "Ptr", index, "CDecl Ptr")

    SDL_GameControllerClose(controller) => DllCall("SDL2.dll\SDL_GameControllerClose", "Ptr", controller, "CDecl")

    SDL_GameControllerGetJoystick(controller) => DllCall("SDL2.dll\SDL_GameControllerGetJoystick", "Ptr", controller, "CDecl Ptr")

    ;;~ retStr control the return value type, most time we just need the string type.
    ; SDL_JoystickGetGUID(joystick, retStr := true) {
    ;     guid := Buffer(16, 0)
    ;     pguid := DllCall("SDL2.dll\SDL_JoystickGetGUID", 'Ptr', guid, "Ptr", joystick, "CDecl Ptr")
    ;     if (!retStr)
    ;         return pguid
    ;     sguid := Buffer(128, 0)
    ;     if (DllCall("ole32.dll\StringFromGUID2", "ptr", pguid, "ptr", sguid, "int", 48))
    ;         return StrGet(sguid)
    ; }

    ; SDL_JoystickGetDeviceGUID(device_index, retStr := true) {
    ;     guid := Buffer(16, 0)
    ;     pguid := DllCall("SDL2.dll\SDL_JoystickGetDeviceGUID", 'Ptr', guid, "Ptr", device_index, "CDecl Ptr")
    ;     if (!retStr)
    ;         return pguid
    ;     sguid := Buffer(128, 0)
    ;     if (DllCall("ole32.dll\StringFromGUID2", "ptr", pguid, "ptr", sguid, "int", 48))
    ;         return StrGet(sguid)
    ; }

    ; void SDL_GUIDToString(SDL_GUID guid, char *pszGUID, int cbGUID);
    ;       guid	the ::SDL_GUID you wish to convert to string
    ;       pszGUID	buffer in which to write the ASCII string
    ;       cbGUID	the size of pszGUID
    ; SDL_GUIDToString(guid,pszGUID,cbGUID){
    ;     DllCall(this.dll . "\SDL_GUIDToString", "Ptr", guid,"Ptr",pszGUID,"int",cbGUID)
    ; }
}
