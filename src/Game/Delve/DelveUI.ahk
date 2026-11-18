global DelveModeDropdown := ""
global DelveIslandDropdown := ""

FukkiSetDelveState(stateName) {
    FukkiSetState("DelveState", stateName)
    if IsSet(DelveStateHeader)
        DelveStateHeader.Value := "STATE: " stateName
}

FukkiSetDelveState("Waiting")

process1.Value := ""
process2.Value := ""
process3.Value := ""
process4.Value := ""
process5.Value := ""
process6.Value := ""
process7.Value := ""

DelveSetProcess(titleText, detailText := "") {
    process1.SetFont("Bold c" uiTheme[7])
    process1.Value := titleText
    process2.SetFont("c" uiTheme[1])
    process2.Value := detailText
}

global DelveRunStartTime := 0
global DelveTotalRuns := 0
global DelveMacroStartTime := 0
global DelveRunDurations := []

DelveStartRunTimer() {
    global DelveRunStartTime
    global DelveMacroStartTime
    global DelveTotalRuns
    global DelveRunDurations
    DelveTotalRuns := 0
    DelveRunDurations := []
    if (DelveMacroStartTime = 0)
        DelveMacroStartTime := A_TickCount
    DelveRunStartTime := A_TickCount
    UpdateDelveRunDisplay()
    SetTimer(UpdateDelveRunDisplay, 1000)
}

DelveResetRunTimer() {
    global DelveRunStartTime, DelveRunDurations
    if (DelveRunStartTime) {
        runLength := A_TickCount - DelveRunStartTime
        if (runLength > 0)
            DelveRunDurations.Push(runLength)
    }
    DelveRunStartTime := A_TickCount
    UpdateDelveRunDisplay()
}

DelveStopRunTimer() {
    SetTimer(UpdateDelveRunDisplay, 0)
    ShowDelveRunReport()
}

DelveFormatDuration(milliseconds) {
    elapsedSeconds := milliseconds // 1000
    hours := elapsedSeconds // 3600
    minutes := Mod(elapsedSeconds // 60, 60)
    seconds := Mod(elapsedSeconds, 60)
    return Format("{:02}:{:02}:{:02}", hours, minutes, seconds)
}

ShowDelveRunReport() {
    global DelveMacroStartTime, DelveRunDurations, DelveTotalRuns, DelveRunStartTime
    islandName := FukkiGetState("DelveIsland", "")
    totalRunTime := DelveMacroStartTime ? A_TickCount - DelveMacroStartTime : 0
    averageRunTime := 0
    sum := 0
    durationCount := DelveRunDurations.Length
    for duration in DelveRunDurations
        sum += duration
    if (DelveRunStartTime) {
        currentDuration := A_TickCount - DelveRunStartTime
        if (currentDuration > 0) {
            sum += currentDuration
            durationCount++
        }
    }
    if (durationCount) {
        averageRunTime := sum // durationCount
    }
    process1.Value := "Map: " islandName
    process2.Value := "Total time: " DelveFormatDuration(totalRunTime)
    process3.Value := "Total runs: " DelveTotalRuns
    process4.Value := "Average run: " DelveFormatDuration(averageRunTime)
    process5.Value := "Status: Stopped"
    process6.Value := ""
    process7.Value := ""
}

UpdateDelveRunDisplay() {
    global DelveRunStartTime := 0
    global DelveTotalRuns := 0
    islandName := FukkiGetState("DelveIsland", "")
    elapsedMilliseconds := 0
    if (DelveRunStartTime > 0)
        elapsedMilliseconds := A_TickCount - DelveRunStartTime
    elapsedSeconds := elapsedMilliseconds // 1000
    hours := elapsedSeconds // 3600
    minutes := Mod(elapsedSeconds // 60, 60)
    seconds := Mod(elapsedSeconds, 60)
    process1.Value := "Map: " islandName
    process2.Value := "Run time: " Format("{:02}:{:02}:{:02}", hours, minutes, seconds)
    process3.Value := "Total runs: " DelveTotalRuns
    process4.Value := ""
    process5.Value := ""
    process6.Value := ""
    process7.Value := ""
}

F1:: {
    moveRobloxWindow()
}

F2:: {
    if !FukkiGetState("DelveReady", false) {
        DelveSetProcess("PLEASE SELECT A MINE AND ISLAND", "")
        return
    }
    if (DelveMovementPattern.Text = "Movement Pattern" || DelveClickPattern.Text = "Mouse Pattern") {
        DelveSetProcess("PLEASE SELECT A MOVEMENT OR A MOUSE PATTERN", "")
        return
    }
    DelveGoToMine()
    DelveSelectIsland()
    DelveEnterMine()
    DelveSetProcess("RUNNING", "Mine loaded")
    DelveStartRunTimer()
    DelveController.Start()
}

F3:: {
    DelveStopRunTimer()
    DelveStop()
}

