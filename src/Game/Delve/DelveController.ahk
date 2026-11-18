class DelveController {
    static LastState := ""
    static EquippedKey := ""
    static CandidateState := ""
    static CandidateCount := 0
    static ReplayLastClick := 0
    static ReplayCandidateCount := 0
    static MovementKey := ""
    static MovementDirection := ""
    static MovementDuration := 2000
    static MousePatternDirection := "Up"
    static MouseSquareIndex := 0

    static Start() {
        modeName := FukkiGetState("DelveMode", "")
        islandName := FukkiGetState("DelveIsland", "")
        if (modeName = "" || islandName = "") {
            FukkiLog("Delve mode and island have not been selected")
            return false
        }

        FukkiLog("Starting Delve - " islandName)
        FukkiSetDelveState("Searching")
        FukkiSetRunning(true)
        DelveController.LastState := ""
        DelveController.EquippedKey := ""
        DelveController.CandidateState := ""
        DelveController.CandidateCount := 0
        DelveController.ReplayLastClick := 0
        DelveController.ReplayCandidateCount := 0
        DelveController.MousePatternDirection := "Up"
        DelveController.MouseSquareIndex := 0
        DelveController.MovementKey := ""
        DelveController.MovementDirection := ""
        SetTimer(DelveTick, 100)
        DelveUpdateAutoReplayTimer()
        return true
    }

    static Stop() {
        SetTimer(DelveTick, 0)
        SetTimer(DelveAutoReplayTick, 0)
        DelveStopMovementPattern()
        DelveStopMousePattern()
        DelveStopAutoDash()
        FukkiSetRunning(false)
        FukkiSetDelveState("Stopped")
    }

    static Tick() {
        foundX := 0
        foundY := 0

        if FukkiFindRegisteredPattern("Delve", "ORE", &foundX, &foundY) {
            DelveController.SetCandidate("ORE", "1")
            return
        }
        if FukkiFindRegisteredPattern("Delve", "MOBS", &foundX, &foundY) {
            DelveController.SetCandidate("MOBS", "2")
            return
        }
        if FukkiFindRegisteredPattern("Delve", "BOSS", &foundX, &foundY) {
            DelveController.SetCandidate("BOSS", "2")
            return
        }
        DelveController.CandidateState := ""
        DelveController.CandidateCount := 0
    }

    static SetCandidate(stateName, keyToSend, foundX := 0, foundY := 0) {
        if (DelveController.CandidateState = stateName) {
            DelveController.CandidateCount++
        } else {
            DelveController.CandidateState := stateName
            DelveController.CandidateCount := 1
        }

        if (DelveController.CandidateCount >= 2)
            DelveController.SetState(stateName, keyToSend, foundX, foundY)
    }

    static SetState(stateName, keyToSend, foundX := 0, foundY := 0) {
        if (DelveController.LastState = stateName)
            return
        DelveController.LastState := stateName
        FukkiSetDelveState(stateName)
        if (DelveController.EquippedKey != keyToSend) {
            DelveController.EquippedKey := keyToSend
            SendInput(keyToSend)
            FukkiLog("Delve state: " stateName " - equipped key " keyToSend)
        }
        if (stateName = "ORE") {
            DelveStartMovementPattern()
            DelveStartMousePattern()
            DelveStartAutoDash()
        } else {
            DelveStopMovementPattern()
            DelveStopMousePattern()
            DelveStopAutoDash()
        }
    }
}

DelveTick() {
    try {
        DelveController.Tick()
    } catch Error as err {
        SetTimer(DelveTick, 0)
        FukkiSetRunning(false)
        FukkiSetDelveState("Error")
        ProcessLog("Delve detector error: " err.Message)
    }
}

DelveStop() {
    DelveController.Stop()
}

DelveGoToMine() {
    DelveSetProcess("OPENING MENU", "Go to Mine...")
    CoordMode "Mouse", "Screen"
    MouseMove(396, 62)
    Sleep(20)
    MouseClick("Left", 396, 62)
}

DelveSelectIsland() {
    islandName := FukkiGetState("DelveIsland", "")
    switch islandName {
        case "GRASSLANDS":
            DelveSetProcess("SELECTING ISLAND", "GRASSLANDS")
            Sleep(500)
            DelveIslandClick(229, 423)
        case "SUN FLATS":
            DelveSetProcess("SELECTING ISLAND", "SUN FLATS")
            Sleep(500)
            DelveIslandClick(332, 418)
        case "FROSTBITE":
            DelveSetProcess("SELECTING ISLAND", "FROSTBITE")
            Sleep(500)
            DelveIslandClick(445, 422)
        case "MYCELIA":
            DelveSetProcess("SELECTING ISLAND", "MYCELIA")
            Sleep(500)
            loop 3
                DelveScrollDown(400, 400)
            Sleep(300)
            DelveIslandClick(246, 424)
        case "PIRATE COVE":
            DelveSetProcess("SELECTING ISLAND", "PIRATE COVE")
            Sleep(500)
            loop 3
                DelveScrollDown(400, 400)
            Sleep(300)
            DelveIslandClick(345, 424)
        case "INFERNIA":
            DelveSetProcess("SELECTING ISLAND", "INFERNIA")
            Sleep(500)
            loop 3
                DelveScrollDown(400, 400)
            Sleep(300)
            DelveIslandClick(447, 422)
        case "THE ABYSS":
            DelveSetProcess("SELECTING ISLAND", "THE ABYSS")
            Sleep(500)
            loop 3
                DelveScrollDown(400, 400)
            Sleep(300)
            DelveIslandClick(264, 421)
    }
}

DelveIslandClick(x, y) {
    CoordMode "Mouse", "Screen"
    MouseMove(x, y)
    Sleep(20)
    MouseClick("Left", x, y)
}

DelveScrollDown(x, y) {
    CoordMode "Mouse", "Screen"
    MouseMove(x, y)
    Sleep(50)
    Send("{WheelDown}")
    Sleep(250)
}

DelveEnterMine() {
    Sleep(1000)
    DelveSetProcess("TELEPORTING", "Entering the mine...")
    CoordMode "Mouse", "Screen"
    loop 4 {
        MouseMove(277, 277)
        Sleep(20)
        MouseClick("Left", 277, 277)
        Sleep(100)
    }
    Sleep(3000)
}

DelveGetGridCount() {
    islandName := FukkiGetState("DelveIsland", "")
    switch islandName {
        case "SUN FLATS": return 7
        case "FROSTBITE": return 8
        case "MYCELIA": return 9
        case "PIRATE COVE": return 10
        case "INFERNIA": return 11
        case "THE ABYSS": return 11
        default: return 6
    }
}

DelveGetMovementDuration() {
    if !IsSet(DelveWalkSpeed)
        return 2000
    walkSpeedText := Trim(DelveWalkSpeed.Text)
    if (walkSpeedText = "")
        return 2000
    walkSpeed := 0
    try walkSpeed := Float(walkSpeedText)
    catch
        return 2000
    if (walkSpeed <= 0)
        return 2000
    if IsSet(DelveLeadenBootsPact) && DelveLeadenBootsPact.Value
        walkSpeed := walkSpeed * 0.75
    gridCount := DelveGetGridCount()
    duration := Round((2000 * (gridCount / 6)) * (34.9 / walkSpeed))
    if (duration < 500)
        duration := 500
    if (duration > 6000)
        duration := 6000
    return duration
}

DelveStartMovementPattern() {
    if !IsSet(DelveMovementPattern)
        return
    if (DelveMovementPattern.Text = "Movement Pattern")
        return
    DelveController.MovementDuration := DelveGetMovementDuration()
    if (DelveMovementPattern.Text = "Right/Left") {
        DelveController.MovementDirection := "Left"
        DelveController.MovementKey := "a"
    } else {
        DelveController.MovementDirection := "Up"
        DelveController.MovementKey := "w"
    }
    SendInput("{" DelveController.MovementKey " down}")
    SetTimer(DelveMovementTick, DelveController.MovementDuration)
}

DelveMovementTick() {
    if (DelveController.MovementKey != "")
        SendInput("{" DelveController.MovementKey " up}")

    if (DelveMovementPattern.Text = "Right/Left") {
        DelveController.MovementDirection := DelveController.MovementDirection = "Left" ? "Right" : "Left"
        DelveController.MovementKey := DelveController.MovementDirection = "Left" ? "a" : "d"
    } else {
        DelveController.MovementDirection := DelveController.MovementDirection = "Up" ? "Down" : "Up"
        DelveController.MovementKey := DelveController.MovementDirection = "Up" ? "w" : "s"
    }
    SendInput("{" DelveController.MovementKey " down}")
}

DelveStopMovementPattern() {
    SetTimer(DelveMovementTick, 0)
    if (DelveController.MovementKey != "")
        SendInput("{" DelveController.MovementKey " up}")
    DelveController.MovementKey := ""
}

DelveStartMousePattern() {
    if !IsSet(DelveClickPattern)
        return
    if (DelveClickPattern.Text = "Mouse Pattern")
        return
    if (DelveClickPattern.Text = "Square")
        DelveController.MousePatternDirection := "Square"
    else if (InStr(DelveClickPattern.Text, "Left/Right"))
        DelveController.MousePatternDirection := "Left"
    else
        DelveController.MousePatternDirection := "Up"
    SetTimer(DelveMousePatternTick, DelveClickPattern.Text = "Square" ? 40 : 50)
}

DelveStopMousePattern() {
    SetTimer(DelveMousePatternTick, 0)
}

DelveStartAutoDash() {
    if !IsSet(DelveAutoDash)
        return
    if (DelveAutoDash.Value)
        SetTimer(DelveAutoDashTick, 500)
}

DelveStopAutoDash() {
    SetTimer(DelveAutoDashTick, 0)
}

DelveAutoDashTick() {
    if !FukkiGetState("Running", false)
        return
    if (FukkiGetState("DelveState", "") != "ORE")
        return
    Send("q")
}

DelveMousePatternTick() {
    if !FukkiGetState("Running", false)
        return
    if (DelveClickPattern.Text = "Square") {
        gridCount := DelveGetGridCount()
        size := Round(75 * gridCount / 6)
        squarePoints := [
            {X: 400 - size, Y: 260 - size},
            {X: 400, Y: 260 - size},
            {X: 400 + size, Y: 260 - size},
            {X: 400 + size, Y: 260},
            {X: 400 + size, Y: 260 + size},
            {X: 400, Y: 260 + size},
            {X: 400 - size, Y: 260 + size},
            {X: 400 - size, Y: 260}
        ]
        point := squarePoints[DelveController.MouseSquareIndex + 1]
        MouseMove(point.X, point.Y)
        DelveController.MouseSquareIndex := Mod(DelveController.MouseSquareIndex + 1, squarePoints.Length)
        return
    }
    if (InStr(DelveClickPattern.Text, "Left/Right")) {
        gridCount := DelveGetGridCount()
        leftX := 400 - Round(25 * gridCount / 6)
        rightX := 400 + Round(25 * gridCount / 6)
        if (DelveController.MousePatternDirection = "Left") {
            MouseMove(leftX, 260)
            DelveController.MousePatternDirection := "Right"
        } else {
            MouseMove(rightX, 260)
            DelveController.MousePatternDirection := "Left"
        }
        return
    }

    if (DelveController.MousePatternDirection = "Up") {
        gridCount := DelveGetGridCount()
        topY := 260 - Round(50 * gridCount / 6)
        MouseMove(400, topY)
        DelveController.MousePatternDirection := "Down"
    } else {
        gridCount := DelveGetGridCount()
        bottomY := 260 + Round(50 * gridCount / 6)
        MouseMove(400, bottomY)
        DelveController.MousePatternDirection := "Up"
    }
}

DelveUpdateAutoReplayTimer() {
    if IsSet(DelveAutoReplay) && DelveAutoReplay.Value && FukkiGetState("Running", false)
        SetTimer(DelveAutoReplayTick, 10)
    else
        SetTimer(DelveAutoReplayTick, 0)
}

DelveAutoReplayTick() {
    if !FukkiGetState("Running", false)
        return
    foundX := 0
    foundY := 0
    if !FukkiFindRegisteredPattern("Delve", "BACK_TO_MINE", &foundX, &foundY) {
        DelveController.ReplayCandidateCount := 0
        return
    }

    DelveController.ReplayCandidateCount++
    if (DelveController.ReplayCandidateCount < 2)
        return

    if (A_TickCount - DelveController.ReplayLastClick < 1000)
        return

    DelveController.ReplayLastClick := A_TickCount
    DelveController.EquippedKey := ""
    global DelveTotalRuns
    CoordMode "Mouse", "Screen"
    MouseMove(foundX, foundY)
    Sleep(20)
    MouseClick("Left", foundX, foundY)
    DelveTotalRuns++
    DelveResetRunTimer()
}
