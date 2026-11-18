# tetoMacro - tetoDelve

AutoHotkey v2 macro for Delve.

## Structure

- `Main.ahk` is the application entry point.
- `src/App.ahk` loads the shared infrastructure and Delve modules.
- `src/Core/` contains state, loop, and input coordination.
- `src/Detection/` contains screen capture and FindText detection.
- `src/Input/` contains keyboard and mouse infrastructure.
- `src/UI/` contains the tetoMacro GUI.
- `src/Utils/` contains configuration and logging.
- `src/Game/Delve/` contains Delve patterns and automation.

The FindText library remains under `Lib/FindText.ahk`.

License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software (the "Software"), to use the Software for personal purposes, subject to the following conditions:

Non-Transferability:
This license is non-transferable and non-exclusive. The Software may only be used by the original recipient.

Prohibition of Redistribution:
Redistribution of this Software, in whole or in part, is strictly prohibited without prior written permission from the author.

Prohibition of Modification:
Modification of the Software, including reverse engineering, decompilation, or disassembly, is strictly prohibited without prior written permission from the author.

Prohibition of Sublicensing:
The licensee may not sublicense or share the Software with any third party without prior written permission from the author.

No Warranty:
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
