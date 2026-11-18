# tetoMacro - tetoDelve

**AutoHotkey v2** macro for the game **Delve** (Roblox).

This project was built on top of an older macro made for another game and has now been recreated and adapted for Delve.

## How it works

- Detects in-game elements on screen using the **FindText** library (image/pattern recognition).
- Automates keyboard and mouse input so you don't have to play manually.
- Switches between the pickaxe (ores) and the sword (monsters) depending on the situation.
- Includes a graphical interface (GUI) to control the macro.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/)
- Game open

## Usage

1. Install AutoHotkey v2.
2. Download or clone this repository.
3. Run `Main.ahk`.
4. Open Delve and start the macro from the interface.

## Project structure

```
tetoDelve/
├── Main.ahk          # Application entry point
├── Images/           # Images used for detection
├── Lib/              # External libraries (FindText.ahk)
├── Settings/         # Saved settings
└── src/
    ├── App.ahk       # Loads the shared infrastructure and Delve modules
    ├── Core/         # State, main loop, and input coordination
    ├── Detection/    # Screen capture and FindText detection
    ├── Input/        # Keyboard and mouse infrastructure
    ├── UI/           # tetoMacro GUI
    ├── Utils/        # Configuration and logging
    └── Game/Delve/   # Delve-specific patterns and automation
```

Terms of use

No modification: modifying, reverse engineering, decompiling, or disassembling the macro is not allowed without prior written permission from the author.]
No redistribution: redistributing the macro, in whole or in part, is not allowed without prior written permission from the author.
No warranty: the software is provided "as is", without warranty of any kind. The author is not liable for any damages or issues arising from its use.
