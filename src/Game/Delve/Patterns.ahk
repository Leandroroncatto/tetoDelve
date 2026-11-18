#Requires AutoHotkey v2.0

; Delve FindText patterns
; Each pattern is registered with the search coordinates: x1, y1, x2, y2

OreText := "|<>**50$19.TzzskkPfvxppuum5R7TlgUjzzs"
OreX1 := 267
OreY1 := 100
OreX2 := 529
OreY2 := 123

MobsText := "|<>**50$25.vzzSLMksffffI5Jpy2e73RRRRelVlxzzjc"
MobsX1 := 267
MobsY1 := 100
MobsX2 := 529
MobsY2 := 123

BossText := "|<>**50$25.zTSSEsssfffPJppxy6f33RRRRVlllzjjjc"
BossX1 := 267
BossY1 := 100
BossX2 := 529
BossY2 := 123

BackToMineText := "|<>**50$37.ztzDzrk7ly6SNtaQtCQwbYzaO0mGMHtDNtA8CbY0rwnHmSNmMs3BD3CDzwxzzy"
BackToMineX1 := 85
BackToMineY1 := 526
BackToMineX2 := 406
BackToMineY2 := 609

if (OreText != "")
    FukkiRegisterPattern("Delve", "ORE", OreText, OreX1, OreY1, OreX2, OreY2)

if (MobsText != "")
    FukkiRegisterPattern("Delve", "MOBS", MobsText, MobsX1, MobsY1, MobsX2, MobsY2)

if (BossText != "")
    FukkiRegisterPattern("Delve", "BOSS", BossText, BossX1, BossY1, BossX2, BossY2)

if (BackToMineText != "")
    FukkiRegisterPattern("Delve", "BACK_TO_MINE", BackToMineText,
        BackToMineX1, BackToMineY1, BackToMineX2, BackToMineY2)
