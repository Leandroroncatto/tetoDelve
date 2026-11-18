FukkiConfigPath(gameName := "") {
    configDir := A_ScriptDir "\Settings"
    if !DirExist(configDir)
        DirCreate(configDir)
    if (gameName != "")
        configDir .= "\" gameName
    if (gameName != "" && !DirExist(configDir))
        DirCreate(configDir)
    return configDir
}

global FukkiPatterns := Map()

FukkiRegisterPattern(gameName, patternName, pattern, x1 := 0, y1 := 0, x2 := 0, y2 := 0) {
    global FukkiPatterns
    if !FukkiPatterns.Has(gameName)
        FukkiPatterns[gameName] := Map()
    FukkiPatterns[gameName][patternName] := {
        Pattern: pattern,
        X1: x1,
        Y1: y1,
        X2: x2,
        Y2: y2
    }
}

FukkiGetPattern(gameName, patternName) {
    global FukkiPatterns
    if !FukkiPatterns.Has(gameName)
        return ""
    return FukkiPatterns[gameName].Has(patternName) ? FukkiPatterns[gameName][patternName] : ""
}
