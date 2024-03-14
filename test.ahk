#Include SDL2.ahk

controllers := Map()
SDL2 := SDL2DLL()
SDL2.SDL_SetHint("SDL_JOYSTICK_THREAD", "1")
SDL2.SDL_SetHint("SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS", "1")
; SDL2.SDL_SetHint("SDL_JOYSTICK_RAWINPUT", "1")
SDL2.SDL_Init(SDL_INIT_GAMECONTROLLER := 0x00002000)
joystickTest()
SDL2.SDL_Quit()
return

joystickTest() {
    SDL2.SDL_JoystickEventState(true)

    loop SDL2.SDL_NumJoysticks() {
        openController(A_index - 1)
    }

    ;AHK doesn't support union, need Buffer to receive SDL_Event
    evtBuffer := Buffer(56, 0)
    backButton := false
    taskSwitching := false
    OutputDebug("JOYSTICK_ALLOW_BACKGROUND_EVENTS=" SDL2.SDL_GetHint("SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS"))
    OutputDebug("JOYSTICK_THREAD=" SDL2.SDL_GetHint("SDL_JOYSTICK_THREAD"))
    loop {
        PollEvent := SDL2.SDL_PollEvent(evtBuffer)
        evt := SDL2DLL.SDL_Event(evtBuffer)

        if (PollEvent = 0) {
            continue
        }
        switch (evt.type) {
            case SDL_EventType.SDL_CONTROLLERBUTTONDOWN, SDL_EventType.SDL_CONTROLLERBUTTONUP:
                ToolTip(SDL2.SDL_JoystickNameForIndex(controllers[evt.cbutton.which].index) "`nButton: " evt.cbutton.button "`nPressState: " evt.cbutton.state "`nEvent: " evt.type)
                switch (evt.cbutton.button) {
                    case SDL_EventType.SDL_CONTROLLER_BUTTON_BACK: ; SDL_CONTROLLER_BUTTON_GUIDE:
                        backButton := (evt.type = SDL_EventType.SDL_CONTROLLERBUTTONDOWN)
                        OutputDebug("back " (evt.type = SDL_EventType.SDL_CONTROLLERBUTTONDOWN ? "down" : "up"))
                    case SDL_EventType.SDL_CONTROLLER_BUTTON_Y:
                        if (taskSwitching && (evt.type = SDL_EventType.SDL_CONTROLLERBUTTONUP)) {
                            taskSwitching := false
                            SendInput("{Alt up}")
                            OutputDebug("Y up")
                        }
                }
                if (evt.type = SDL_EventType.SDL_CONTROLLERBUTTONDOWN) {
                    if (backButton) {
                        switch (evt.cbutton.button) {
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_B:
                                SendEvent("!{F4}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_A:
                                SendEvent("{Enter}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_LEFTSHOULDER:
                                SendEvent("+{Tab}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_RIGHTSHOULDER:
                                SendEvent("{Tab}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_Y:
                                taskSwitching := true
                                OutputDebug "Y down"
                                SendInput("{Alt down}{tab}")
                        }
                    }
                    if (backButton || taskSwitching) {
                        switch (evt.cbutton.button) {
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_DPAD_LEFT:
                                SendEvent("{Left}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_DPAD_RIGHT:
                                SendEvent("{Right}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_DPAD_UP:
                                SendEvent("{Up}")
                            case SDL_EventType.SDL_CONTROLLER_BUTTON_DPAD_DOWN:
                                SendEvent("{Down}")
                        }
                    }
                }
            case SDL_EventType.SDL_CONTROLLERAXISMOTION:
                ; ToolTip(SDL2.SDL_JoystickNameForIndex(controllers[evt.caxis.which].index) . "`nSDL_JOYAXISMOTION: " evt.caxis.value "`nDirection:" evt.caxis.axis)
            case SDL_EventType.SDL_CONTROLLERDEVICEADDED:
                openController(evt.cdevice.which)

            case SDL_EventType.SDL_CONTROLLERDEVICEREMOVED:
                closeController(evt.cdevice.which)
        }
        SDL2.SDL_Delay(1)
    }
}

openController(index) {
    if (SDL2.SDL_IsGameController(index)) {
        controller := SDL2.SDL_GameControllerOpen(index)
        joystick := SDL2.SDL_GameControllerGetJoystick(controller)
        instance := SDL2.SDL_JoystickInstanceID(joystick)
        controllers[instance] := {
            controller: controller,
            joystick: joystick,
            instance: instance,
            index: index
        }
    }
}

closeController(instance) {
    SDL2.SDL_GameControllerClose(controllers[instance].controller)
    controllers.Delete(instance)
}
