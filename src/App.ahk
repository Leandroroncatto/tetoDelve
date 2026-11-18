#Requires AutoHotkey v2.0
SendMode "Event"

; Shared infrastructure
#Include %A_ScriptDir%\src\Core\StateManager.ahk
#Include %A_ScriptDir%\src\Core\GameLoop.ahk
#Include %A_ScriptDir%\src\Core\InputManager.ahk
#Include %A_ScriptDir%\src\Detection\ScreenCapture.ahk
#Include %A_ScriptDir%\src\Detection\FindTextDetector.ahk
#Include %A_ScriptDir%\src\Input\Keyboard.ahk
#Include %A_ScriptDir%\src\Input\Mouse.ahk
#Include %A_ScriptDir%\src\Utils\Logger.ahk
#Include %A_ScriptDir%\src\Utils\Config.ahk

; External libraries
#Include %A_ScriptDir%\Lib\FindText.ahk
#Include %A_ScriptDir%\Lib\imageForCS.ahk
#Include %A_ScriptDir%\Lib\ImagePut.ahk
#Include %A_ScriptDir%\Lib\AHKv2-Gdip-master\Gdip_All.ahk

; Shared UI and assets
#Include %A_ScriptDir%\src\UI\Assets.ahk
#Include %A_ScriptDir%\src\UI\GUI.ahk

; Game modules
#Include %A_ScriptDir%\src\Game\GameController.ahk
#Include %A_ScriptDir%\src\Game\Delve\DelveUI.ahk
#Include %A_ScriptDir%\src\Game\Delve\DelveModeSelection.ahk
#Include %A_ScriptDir%\src\Game\Delve\Patterns.ahk
#Include %A_ScriptDir%\src\Game\Delve\WalkSpeedHelp.ahk
