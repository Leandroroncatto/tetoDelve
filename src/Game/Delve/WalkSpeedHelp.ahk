ShowWalkSpeedHelp() {
    helpGui := Gui("+AlwaysOnTop")
    helpGui.BackColor := "0x141417"
    helpGui.SetFont("s11 cWhite", "Segoe UI")
    helpGui.Add("Text", "w500 Center", "Walk Speed Recommendation")
    helpGui.SetFont("s10 cWhite", "Segoe UI")
    helpGui.Add("Text", "w500",
        "Recommended: enter your character's current Walk Speed value"
        "`nEnter the exact value shown in the highlighted WALK SPEED row.")
    if FileExist(A_ScriptDir "\Images\WalkSpeedHelp.png")
        helpGui.Add("Picture", "w500", "Images\WalkSpeedHelp.png")
    helpGui.Add("Button", "x210 y+12 w80 h28", "Close").OnEvent("Click", (*) => helpGui.Destroy())
    helpGui.Show("w520")
}
