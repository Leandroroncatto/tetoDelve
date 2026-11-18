FukkiSetRunning(running) {
    FukkiSetState("Running", running)
}

FukkiRunLoop(gameController) {
    if (gameController = "") {
        return false
    }
    FukkiSetRunning(true)
    return gameController.Start()
}
