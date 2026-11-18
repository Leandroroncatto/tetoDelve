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

FukkiReadText(relativePath) {
    fullPath := A_ScriptDir "\" relativePath
    return FileExist(fullPath) ? FileRead(fullPath, "UTF-8") : ""
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

FukkiPatternConfigFile(gameName) {
    return FukkiConfigPath(gameName) "\Patterns.ini"
}

FukkiSavePattern(gameName, patternName) {
    registered := FukkiGetPattern(gameName, patternName)
    if (registered = "")
        return false
    configFile := FukkiPatternConfigFile(gameName)
    IniWrite(registered.Pattern, configFile, patternName, "Pattern")
    IniWrite(registered.X1, configFile, patternName, "X1")
    IniWrite(registered.Y1, configFile, patternName, "Y1")
    IniWrite(registered.X2, configFile, patternName, "X2")
    IniWrite(registered.Y2, configFile, patternName, "Y2")
    return true
}

FukkiLoadPattern(gameName, patternName) {
    configFile := FukkiPatternConfigFile(gameName)
    if !FileExist(configFile)
        return false
    pattern := IniRead(configFile, patternName, "Pattern", "")
    if (pattern = "")
        return false
    FukkiRegisterPattern(gameName, patternName, pattern,
        Integer(IniRead(configFile, patternName, "X1", "0")),
        Integer(IniRead(configFile, patternName, "Y1", "0")),
        Integer(IniRead(configFile, patternName, "X2", "0")),
        Integer(IniRead(configFile, patternName, "Y2", "0")))
    return true
}
