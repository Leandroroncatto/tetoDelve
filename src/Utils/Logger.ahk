FukkiLog(message) {
    try {
        ProcessLog(message)
        return
    } catch
    {}
    try {
        if !DirExist(A_ScriptDir "\Logs")
            DirCreate(A_ScriptDir "\Logs")
        FileAppend(Format("{} {}", FormatTime(A_Now, "HH:mm:ss"), message) "`n", A_ScriptDir "\Logs\LogFile.txt")
    } catch
    {}
}
