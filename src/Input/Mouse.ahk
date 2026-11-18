FukkiMouseMoveAbsolute(x, y) {
    MouseMove(x, y)
}

FukkiMouseClickRelative(button, relativeX := -1, relativeY := 0) {
    if (relativeX = -1) {
        Click(button)
    } else {
        MouseClick(button, relativeX, relativeY)
    }
}
