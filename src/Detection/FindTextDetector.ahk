FukkiClickText(foundX, foundY, relativeX := 0, relativeY := 0) {
    return FindText().Click(foundX + relativeX, foundY + relativeY, "L")
}

FukkiFindRegisteredPattern(gameName, patternName, &foundX, &foundY, textColor := 0, bgColor := 0) {
    registered := FukkiGetPattern(gameName, patternName)
    if (registered = "")
        return false
    return FindText(&foundX, &foundY,
        registered.X1, registered.Y1, registered.X2, registered.Y2,
        textColor, bgColor, registered.Pattern)
}
