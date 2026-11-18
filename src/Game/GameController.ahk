#Include %A_ScriptDir%\src\Game\Delve\DelveController.ahk

class GameController {
    static Start(gameName := "") {
        if (gameName = "")
            gameName := FukkiGetState("Game")

        switch gameName {
            case "Delve":
                FukkiSetState("Game", "Delve")
                return DelveController.Start()
            default:
                FukkiLog("Unknown game module: " gameName)
                return false
        }
    }
}

FukkiStartGame(gameName := "") {
    if (gameName != "")
        FukkiSetState("Game", gameName)
    return FukkiRunLoop(GameController)
}
