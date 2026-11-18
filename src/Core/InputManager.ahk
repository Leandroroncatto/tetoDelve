FukkiSendKeys(keys) {
    SendInput(keys)
}

FukkiMoveMouse(x, y) {
    MouseMove(x, y)
}

FukkiMouseClick(button := "Left", x := -1, y := 0) {
    if (x = -1) {
        MouseClick(button)
    } else {
        MouseClick(button, x, y)
    }
}
