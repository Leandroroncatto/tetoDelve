global FukkiState := Map(
    "Game", "Delve",
    "Running", false,
    "Mode", ""
)

FukkiSetState(key, value) {
    global FukkiState
    FukkiState[key] := value
}

FukkiGetState(key, default := "") {
    global FukkiState
    return FukkiState.Has(key) ? FukkiState[key] : default
}

FukkiSetRunning(running) {
    FukkiSetState("Running", running)
}
