class DelveController {
    static LastState := ""
    static EquippedKey := ""
    static ScanCount := 0
    static CandidateState := ""
    static CandidateCount := 0
    static ReplayLastClick := 0
    static ReplayCandidateCount := 0
    static MovementKey := ""
    static MovementDirection := ""
    static MovementDuration := 2000
    static MousePatternTimerActive := false
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
        DelveController.ScanCount := 0
        DelveController.CandidateState := ""
        DelveController.CandidateCount := 0
        DelveController.ReplayLastClick := 0
        DelveController.ReplayCandidateCount := 0
        DelveController.MousePatternDirection := "Up"
        DelveController.MouseSquareIndex := 0
        DelveController.MouseSquareIndex := 0
        DelveController.MovementKey := ""
        DelveController.MovementDirection := ""
        SetTimer(DelveTick, 100)
        DelveUpdateAutoReplayTimer()
        DelveStartMovementPattern()
        DelveStartMousePattern()
        return true
    }

    static Stop() {
        SetTimer(DelveTick, 0)
        SetTimer(DelveAutoReplayTick, 0)
        DelveStopMovementPattern()
        DelveStopMousePattern()
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
    gridCount := 6
    islandName := FukkiGetState("DelveIsland", "")
    switch islandName {
        case "GRASSLANDS": gridCount := 6
        case "SUN FLATS": gridCount := 7
        case "FROSTBITE": gridCount := 8
        case "MYCELIA": gridCount := 9
        case "PIRATE COVE": gridCount := 10
        case "INFERNIA": gridCount := 11
        case "THE ABYSS": gridCount := 11
    }
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
    DelveController.MousePatternTimerActive := true
    if (DelveClickPattern.Text = "Square")
        DelveController.MousePatternDirection := "Square"
    else if (InStr(DelveClickPattern.Text, "Left/Right"))
        DelveController.MousePatternDirection := "Left"
    else
        DelveController.MousePatternDirection := "Up"
    SetTimer(DelveMousePatternTick, DelveClickPattern.Text = "Square" ? 40 : 50)
}

DelveStopMousePattern() {
    DelveController.MousePatternTimerActive := false
    SetTimer(DelveMousePatternTick, 0)
}

DelveMousePatternTick() {
    if !FukkiGetState("Running", false)
        return
    if (DelveClickPattern.Text = "Square") {
        squarePoints := [
            {X: 325, Y: 185},
            {X: 400, Y: 185},
            {X: 475, Y: 185},
            {X: 475, Y: 260},
            {X: 475, Y: 335},
            {X: 400, Y: 335},
            {X: 325, Y: 335},
            {X: 325, Y: 260}
        ]
        point := squarePoints[DelveController.MouseSquareIndex + 1]
        MouseMove(point.X, point.Y)
        DelveController.MouseSquareIndex := Mod(DelveController.MouseSquareIndex + 1, squarePoints.Length)
        return
    }
    if (InStr(DelveClickPattern.Text, "Left/Right")) {
        if (DelveController.MousePatternDirection = "Left") {
            MouseMove(120, 260)
            DelveController.MousePatternDirection := "Right"
        } else {
            MouseMove(680, 260)
            DelveController.MousePatternDirection := "Left"
        }
        return
    }

    if (DelveController.MousePatternDirection = "Up") {
        MouseMove(400, 80)
        DelveController.MousePatternDirection := "Down"
    } else {
        MouseMove(400, 330)
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
