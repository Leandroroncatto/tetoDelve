#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic Application Info
global aaTitle := "tetoMacro"
global version := " - tetoDelve"
global rblxID := "ahk_exe RobloxPlayerBeta.exe"
;Coordinate and Positioning Variables
global targetWidth := 816
global targetHeight := 638
global offsetX := -5
global offsetY := 1
global WM_SIZING := 0x0214
global WM_SIZE := 0x0005
global centerX := 408
global centerY := 320
;State Variables
;Statistics Tracking
global mode := ""
global StartTime := A_TickCount
global currentTime := getCurrentTime()
;Gui creation
global uiBorders := []
global uiBackgrounds := []
global uiTheme := []
global aaMainUI := Gui("+AlwaysOnTop -Caption")
global lastlog := ""
global aaMainUIHwnd := aaMainUI.Hwnd
;Theme colors
uiTheme.Push("0xffffff")  ; Header color
uiTheme.Push("0x141417")  ; Background color
uiTheme.Push("0x232329")    ; Border color
uiTheme.Push("0x232329")  ; Accent color
uiTheme.Push("0x3d3c36")   ; Trans color
uiTheme.Push("000000")    ; Textbox color
uiTheme.Push("ff5081") ; HighLight
;Logs
global currentOutputFile := A_ScriptDir "\Logs\LogFile.txt"

if !DirExist(A_ScriptDir "\Logs") {
    DirCreate(A_ScriptDir "\Logs")
}
if !DirExist(A_ScriptDir "\Settings") {
    DirCreate(A_ScriptDir "\Settings")
}

getCurrentTime() {
    return Format("{:d}h.{:02}m.{:02}s", A_Hour, A_Min, A_Sec)
}

setupOutputFile() {
    content := "`n==" aaTitle "" version "==`n  Start Time: [" currentTime "]`n"
    FileAppend(content, currentOutputFile)
}

minimizeUI(*) {
    aaMainUI.Minimize()
}

Destroy(*) {
    aaMainUI.Destroy()
    ExitApp
}

setupOutputFile()

;------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------MAIN UI------
aaMainUI.BackColor := uiTheme[2]
uiBorders.Push(aaMainUI.Add("Text", "x0 y0 w1364 h1 +Background" uiTheme[3]))  ;Top line
uiBorders.Push(aaMainUI.Add("Text", "x0 y0 w1 h630 +Background" uiTheme[3]))   ;Left line
uiBorders.Push(aaMainUI.Add("Text", "x1363 y0 w1 h630 +Background" uiTheme[3])) ;Right line
uiBackgrounds.Push(aaMainUI.Add("Text", "x3 y3 w1360 h27 +Background" uiTheme[2])) ;Title Top
uiBorders.Push(aaMainUI.Add("Text", "x0 y30 w1363 h1 +Background" uiTheme[3])) ;Title bottom
uiBorders.Push(aaMainUI.Add("Text", "x802 y30 w1 h600 +Background" uiTheme[3])) ;Roblox Right
uiBorders.Push(aaMainUI.Add("Text", "x803 y433 w560 h1 +Background" uiTheme[3])) ;Process Top
uiBorders.Push(aaMainUI.Add("Text", "x803 y461 w560 h1 +Background" uiTheme[3])) ;Process bottom
uiBorders.Push(aaMainUI.Add("Text", "x0 y630 w1364 h1 +Background" uiTheme[3], "")) ;Roblox bottom

AddImageToGui(gui, image, options, text := "") {
    static WS_CHILD := 0x40000000   ; Creates a child window.
    static WS_VISIBLE := 0x10000000   ; Show on creation.
    static WS_DISABLED := 0x8000000   ; Disables Left Click to drag.
    ImagePut.gdiplusStartup()
    pBitmap := ImagePutBitmap(image)
    DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width := 0)
    DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height := 0)
    display := Gui.Add("Text", options " w" width " h" height, text)
    display.imagehwnd := ImagePut.show(pBitmap, , [0, 0], WS_CHILD | WS_VISIBLE | WS_DISABLED, , display.hwnd)
    ImagePut.gdiplusShutdown()
    return display
}

AddImageToGui(aaMainUI, TetoGif, "xm+0 x1238 y530")
global FakeFukki := aaMainUI.Add("Picture", "x1270 y550 w80 h80 +BackgroundTrans", Discord)

;Global Fukki := aaMainUI.Add("Picture", "x1238 y530 w125 h100", Fukki)
;aaMainUI.Add("ActiveX", "x1238 y530 w125 h100 vWmp", "mshtml:<img src='" Fukki "' />")

global robloxHolder := aaMainUI.Add("Text", "x3 y33 w797 h597 +Background" uiTheme[5], "") ;Roblox window box
global Discord := aaMainUI.Add("Picture", "x1270 y4 w24 h24 +BackgroundTrans", Discord) ;Discord logo
;Discord.OnEvent("Click", (*) => OpenDiscordLink()) ;Open discord
global exitButton := aaMainUI.Add("Picture", "x1330 y1 w32 h32 +BackgroundTrans", Exitbutton) ;Exit image
exitButton.OnEvent("Click", (*) => Destroy()) ;Exit button
global minimizeButton := aaMainUI.Add("Picture", "x1300 y3 w27 h27 +Background" uiTheme[2], Minimize) ;Minimize gui
minimizeButton.OnEvent("Click", (*) => minimizeUI()) ;Minimize gui
aaMainUI.SetFont("Bold s16 q5 c" uiTheme[1], "Segoe UI") ;Font
global windowTitle := aaMainUI.Add("Text", "x10 y3 w1200 h29 +BackgroundTrans", aaTitle "" . "" version) ;Title
aaMainUI.Add("Text", "x805 y432 w558 h25 +Center +BackgroundTrans", "Process") ;Process header
aaMainUI.SetFont("norm s10 q5 c" uiTheme[1], "Segoe UI") ;Font
global process1 := aaMainUI.Add("Text", "x810 y470 w538 h18 +BackgroundTrans c" uiTheme[7], "") ;Processes
global process2 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "")
global process3 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "")
global process4 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "")
global process5 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "")
global process6 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "")
global process7 := aaMainUI.Add("Text", "xp yp+22 w538 h18 +BackgroundTrans", "")
WinSetTransColor(uiTheme[5], aaMainUI) ;Roblox window box


aaMainUI.SetFont("s12 Bold c" uiTheme[1], "Segoe UI")
;global settingsBtn := aaMainUI.Add("Button", "x1160 y0 w90 h30", "Settings")

aaMainUI.SetFont("bold s9 q5 c" uiTheme[1], "Segoe UI")
Hotkeytext := aaMainUI.Add("Text", "x807 y35 w200 h30", "F1: Position roblox")
Hotkeytext2 := aaMainUI.Add("Text", "x807 y50 w200 h30", "F2: Start Delve")
Hotkeytext3 := aaMainUI.Add("Text", "x807 y65 w200 h30", "F3: Stop macro")
;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT;--------------MODE SELECT
global modeSelectionGroup := aaMainUI.Add("GroupBox", "x808 y120 w500 h45 Background" uiTheme[2], "Mode Select")
aaMainUI.SetFont("s10 c" uiTheme[1])
global ModeDropdown := aaMainUI.Add("DropDownList", "x818 y135 w140 h180 Choose1 +Center", ["Mine"])
global StoryDropdown := aaMainUI.Add("DropDownList", "x968 y135 w150 h180 Choose0 +Center", [
    "GRASSLANDS", "SUN FLATS", "FROSTBITE", "MYCELIA", "PIRATE COVE", "INFERNIA", "THE ABYSS"])
global ConfirmButton := aaMainUI.Add("Button", "x1218 y135 w80 h25", "Confirm")

if (FukkiGetState("Game") = "Delve") {
    aaMainUI.SetFont("Bold s11 q5 c" uiTheme[2], "Segoe UI")
    global DelveStateHeader := aaMainUI.Add("Text", "x808 y82 w550 h32 +Center +0x200 +Background" uiTheme[7],
        "STATE: WAITING")
    aaMainUI.SetFont("bold s9 q5 c" uiTheme[1], "Segoe UI")
    global DelveAutoReplay := aaMainUI.Add("Checkbox", "x808 y175 w170 h24", "Auto Replay")
    DelveAutoReplay.OnEvent("Click", (*) => DelveUpdateAutoReplayTimer())
    global DelveMovementPattern := aaMainUI.Add("DropDownList", "x988 y175 w170 h180 Choose1 +Center",
        ["Movement Pattern", "Right/Left", "Top/Bottom"])
    global DelveClickPattern := aaMainUI.Add("DropDownList", "x1168 y175 w170 h180 Choose1 +Center",
        ["Mouse Pattern", "Left/Right", "Top/Bottom", "Square"])
    global DelveSaveConfigButton := aaMainUI.Add("Picture",
        "x805 y400 w25 h28 +BackgroundTrans", SaveImg)
    DelveSaveConfigButton.OnEvent("Click", (*) => SaveDelveConfig())
    aaMainUI.SetFont("bold s9 q5 c" uiTheme[1], "Segoe UI")
    global DelveAutoDash := aaMainUI.Add("Checkbox", "x808 y205 w170 h24", "Auto Dash")
    global DelveAutoDashHelp := aaMainUI.Add("Text", "x978 y205 w18 h18 +Center +Border", "?")
    DelveAutoDashHelp.OnEvent("Click", (*) => MsgBox(
        "Auto Dash sends Q every 500 ms while ORE is detected."
        "`nIt is not recommended because it can break the timing of your movement pattern."
        "`nDisable it if Left/Right or Top/Bottom movement becomes inconsistent.",
        "Auto Dash",
        "Ok Iconi"))
    aaMainUI.Add("Text", "x808 y240 w90 h20", "Walk Speed")
    global DelveWalkSpeed := aaMainUI.Add("Edit", "x888 y238 w55 h22 Number c" uiTheme[7], "34.9")
    global DelveWalkSpeedHelp := aaMainUI.Add("Picture", "x948 y238 w18 h18", HelpImg)
    DelveWalkSpeedHelp.OnEvent("Click", (*) => ShowWalkSpeedHelp())
    global DelveLeadenBootsPact := aaMainUI.Add("Checkbox", "x988 y238 w170 h24", "Leaden Boots Pact")
}

StoryDropdown.Visible := true
Hotkeytext.Visible := false
Hotkeytext2.Visible := false
Hotkeytext3.Visible := false
Hotkeytext.Text := "F1: Position roblox"
Hotkeytext2.Text := "F2: Start Delve"
Hotkeytext3.Text := "F3: Stop macro"
ModeDropdown.OnEvent("Change", OnModeChange)
ConfirmButton.OnEvent("Click", OnConfirmClick)
if (FukkiGetState("Game") = "Delve")
    LoadDelveConfig()
;------UNIT CONFIGURATION------UNIT CONFIGURATION------UNIT CONFIGURATION/------UNIT CONFIGURATION/------UNIT CONFIGURATION/------UNIT CONFIGURATION/


aaMainUI.Show("w1366 h633")

WinMove(0, 0, , , "ahk_id " aaMainUIHwnd)
forceRobloxSize()  ; Initial force size and position
SetTimer(checkRobloxSize, 600000)  ; Check every 10 minutes
;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS;------FUNCTIONS

;Process text
ProcessLog(current) {
    global process1, process2, process3, process4, process5, process6, process7, currentOutputFile

    ; Remove arrow from all lines first
    process7.Value := StrReplace(process6.Value, "➤ ", "")
    process6.Value := StrReplace(process5.Value, "➤ ", "")
    process5.Value := StrReplace(process4.Value, "➤ ", "")
    process4.Value := StrReplace(process3.Value, "➤ ", "")
    process3.Value := StrReplace(process2.Value, "➤ ", "")
    process2.Value := StrReplace(process1.Value, "➤ ", "")

    ; Add arrow only to newest process
    process1.Value := "➤ " . current

    elapsedTime := getElapsedTime()
    Sleep(50)
    FileAppend(current . " " . elapsedTime . "`n", currentOutputFile)

}

;Timer
getElapsedTime() {
    global StartTime
    ElapsedTime := A_TickCount - StartTime
    Minutes := Mod(ElapsedTime // 60000, 60)
    Seconds := Mod(ElapsedTime // 1000, 60)
    return Format("{:02}:{:02}", Minutes, Seconds)
}

;Basically the code to move roblox, below

sizeDown() {
    global rblxID

    if !WinExist(rblxID)
        return

    WinGetPos(&X, &Y, &OutWidth, &OutHeight, rblxID)

    ; Exit fullscreen if needed
    if (OutWidth >= A_ScreenWidth && OutHeight >= A_ScreenHeight) {
        Send "{F11}"
        Sleep(100)
    }

    ; Force the window size and retry if needed
    loop 3 {
        WinMove(X, Y, targetWidth, targetHeight, rblxID)
        Sleep(100)
        WinGetPos(&X, &Y, &OutWidth, &OutHeight, rblxID)
        if (OutWidth == targetWidth && OutHeight == targetHeight)
            break
    }
}

moveRobloxWindow() {
    global aaMainUIHwnd, offsetX, offsetY, rblxID

    if !WinExist(rblxID) {
        ProcessLog("Waiting for Roblox window...")
        return
    }

    ; First ensure correct size
    sizeDown()

    ; Then move relative to main UI
    WinGetPos(&x, &y, &w, &h, aaMainUIHwnd)
    WinMove(x + offsetX, y + offsetY, , , rblxID)
    WinActivate(rblxID)
}

forceRobloxSize() {
    global rblxID

    if !WinExist(rblxID) {
        checkCount := 0
        while !WinExist(rblxID) {
            Sleep(5000)
            if (checkCount >= 5) {
                ProcessLog("Attempting to locate the Roblox window")
            }
            checkCount += 1
            if (checkCount > 12) { ; Give up after 1 minute
                ProcessLog("Could not find Roblox window")
                return
            }
        }
        ProcessLog("Found Roblox window")
    }

    WinActivate(rblxID)
    sizeDown()
    moveRobloxWindow()
}
; Function to periodically check window size
checkRobloxSize() {
    global rblxID
    if WinExist(rblxID) {
        WinGetPos(&X, &Y, &OutWidth, &OutHeight, rblxID)
        if (OutWidth != targetWidth || OutHeight != targetHeight) {
            sizeDown()
            moveRobloxWindow()
        }
    }
}
;Basically the code to move roblox, Above

checkSizeTimer() {
    if (WinExist("ahk_exe RobloxPlayerBeta.exe")) {
        WinGetPos(&X, &Y, &OutWidth, &OutHeight, "ahk_exe RobloxPlayerBeta.exe")
        if (OutWidth != 816 || OutHeight != 638) {
            ProcessLog("Fixing Roblox window size")
            moveRobloxWindow()
        }
    }
}
