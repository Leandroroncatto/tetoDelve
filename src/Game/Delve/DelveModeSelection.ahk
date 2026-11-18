DelveConfigure(modeName, islandName) {
    FukkiSetState("DelveMode", modeName)
    FukkiSetState("DelveIsland", islandName)
    FukkiSetState("DelveReady", true)
}

OnModeChange(*) {
    global mode
    selected := ModeDropdown.Text
    StoryDropdown.Visible := (selected = "Mine")
    mode := "Mine"
}

OnConfirmClick(*) {
    if (ModeDropdown.Text = "") {
        ProcessLog("Please select Mine")
        return
    }
    if (StoryDropdown.Text = "") {
        ProcessLog("Please select a Delve island")
        return
    }
    DelveConfigure(ModeDropdown.Text, StoryDropdown.Text)
    Hotkeytext.Visible := true
    Hotkeytext2.Visible := true
    Hotkeytext3.Visible := true
}

SaveDelveConfig(*) {
    if (StoryDropdown.Text = "") {
        ProcessLog("Please select a Delve island before saving")
        return
    }
    configFile := A_ScriptDir "\Settings\Configuration.txt"
    content := "Game=Delve`n"
    content .= "Mode=" ModeDropdown.Text "`n"
    content .= "Island=" StoryDropdown.Text "`n"
    content .= "AutoReplay=" (DelveAutoReplay.Value ? "1" : "0") "`n"
    content .= "MovementPattern=" DelveMovementPattern.Text "`n"
    content .= "ClickPattern=" DelveClickPattern.Text "`n"
    content .= "WalkSpeed=" DelveWalkSpeed.Value "`n"
    content .= "AutoDash=" (DelveAutoDash.Value ? "1" : "0") "`n"
    content .= "LeadenBootsPact=" (DelveLeadenBootsPact.Value ? "1" : "0") "`n"
    if FileExist(configFile)
        FileDelete(configFile)
    FileAppend(content, configFile)
    ProcessLog("Delve configuration saved")
}

LoadDelveConfig() {
    if !IsSet(ModeDropdown) || !IsSet(StoryDropdown)
        return
    if !IsSet(DelveAutoReplay)
        return
    configFile := A_ScriptDir "\Settings\Configuration.txt"
    if !FileExist(configFile)
        return
    content := FileRead(configFile)
    for line in StrSplit(content, "`n") {
        if line = ""
            continue
        parts := StrSplit(line, "=")
        switch parts[1] {
            case "Game":
                continue
            case "Mode":
                if parts.Length >= 2
                    ModeDropdown.Text := parts[2]
            case "Island":
                if parts.Length >= 2
                    StoryDropdown.Text := parts[2]
            case "AutoReplay":
                if parts.Length >= 2
                    DelveAutoReplay.Value := parts[2] = "1"
            case "WalkSpeed":
                if parts.Length >= 2
                    DelveWalkSpeed.Value := parts[2] != "" ? parts[2] : "34.9"
            case "AutoDash":
                if parts.Length >= 2
                    DelveAutoDash.Value := parts[2] = "1"
            case "LeadenBootsPact":
                if parts.Length >= 2
                    DelveLeadenBootsPact.Value := parts[2] = "1"
            case "MovementPattern":
                if parts.Length >= 2
                    switch parts[2] {
                        case "Right/Left", "Top/Bottom":
                            DelveMovementPattern.Text := parts[2]
                        default:
                            DelveMovementPattern.Text := "Movement Pattern"
                    }
            case "ClickPattern":
                if parts.Length >= 2
                    switch parts[2] {
                        case "Left/Right", "Top/Bottom", "Square":
                            DelveClickPattern.Text := parts[2]
                        default:
                            DelveClickPattern.Text := "Mouse Pattern"
                    }
        }
    }
    if (StoryDropdown.Text != "") {
        DelveConfigure(ModeDropdown.Text, StoryDropdown.Text)
        DelveUpdateAutoReplayTimer()
    }
}
