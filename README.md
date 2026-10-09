# Dex# v12.0 (DexPlusPlusPlusPlus)
![DevTool Dex#](https://img.shields.io/badge/Devtool-Dex++++-green)
![Roblox Luau](https://img.shields.io/badge/Roblox-Luau-blue)
![lua script](https://img.shields.io/badge/lua-script-black)

### Dex# is an extended version of Dex and Dex++

[![简体中文 SimplifiedChinese](https://img.shields.io/badge/简体中文-Chinese-red?style=flat-square&labelColor=black)](https://github.com/snmwdd/DexPlusPlusPlusPlus/blob/main/README_CN.md)
[![English 英文](https://img.shields.io/badge/English-英文-blue?style=flat-square&labelColor=black)](https://github.com/snmwdd/DexPlusPlusPlusPlus/blob/main/README.md)


![Preview](./image/截屏2026-10-04%2016.52.58.png)

[More](./image.md)

## Latest Version Script
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/snmwdd/DexPlusPlusPlusPlus/refs/heads/main/script.lua"))()
```

## What's the difference between Dex# and Dex++?

Dex# is a customized rebuild of Dex++, adding new selection and editing tools, language options, and interface fixes.

Here are the features that were added/fixed in Dex#:

- Click GUI to select, with automatic Explorer navigation and blue selection outlines
- GUI picking supports PlayerGui and CoreGui, excluding only Dex's own interfaces and the executor's hidden container contents
- Move, Scale, and Rotate tools for selected GUI objects and parts
- GUI resize handles, rotation controls, and position/size guides
- Native three-axis movement, scaling, and rotation handles for parts
- Mouse and touch support for GUI selection and editing
- English / 中文 language switching in Settings, with English as the default
- Translate Properties below Language is enabled by default; Chinese property labels and categories update immediately, support English/Chinese searches, and the preference is saved
- Fully localized Save Instance options, with Decompile Scripts disabled by default
- Gray translucent File Manager in the Dex# menu for the executor's Workspace directory, with search, creation, text editing/saving and confirmed deletion; text previews are limited to 256 KB
- File Manager uses icon-only controls with localized hover tips, distinct folder/document icons and a grayscale Lua logo for `.lua`/`.luau` files; narrow windows can scroll the toolbar horizontally
- Switch to Game Resources in the same window to search live images/textures and models, preview them, edit image asset references, copy asset IDs/instance paths, locate instances in Explorer, export models into the last Workspace folder, and confirm reference clearing/model deletion. Previews use script-free copies; changes affect the current client session. Resource rows are virtualized for large lists
- `spy` in the Dex# menu, adapted from the supplied Chinese bundle by **deivid and upio**, credited in Dex's contributor information. It starts when first opened and uses a native Dex window with gray translucent controls and Dex typography. The native Dex close button stops and unloads capture; minimizing keeps capture running. Original Cobalt close/minimize controls are removed. Dialogs use sibling layering so main-page rows do not cover their controls. Duplicate standalone Cobalt instances are detected, and failed startup exposes diagnostics with retry. Cobalt's internal Chinese interface and original features are retained
- Compact decompiler menu and an ASCII `Re-Deobf` button
- Adds lua.expert/demo and [Luaunveil](https://github.com/Luaunveil/luau-decompiler), alongside Konstant, AdvancedDecompiler, Shiny, and Executor modes

  > `getscriptbytecode` is required for non-Executor modes.

- Improved DataModel root compatibility to address empty Explorer trees
- Improved Script Viewer toolbar layout across different window sizes
- Fixed repeated settings dialog creation and invalid transparency inputs

## To Build
1. Download this repository
2. Ensure you have Python 3
3. Run build.py
4. The executable script will be created as out.lua

## Credits
- [Chillz](https://github.com/AZYsGithub) – Dex++ Maintainer  
- [Cazan](https://github.com/Cazzanos) – Helped me develop the Model Viewer  
- [Moon](https://github.com/LorekeeperZinnia/Dex) – Original Dex Explorer  
- [Toon](https://github.com/Toon-arch) – Contributor and IY's Dex parts and components
- [ChatGPT6.1](chatgpt.com) - Help me write code
- [luau-decompiler](https://github.com/Luaunveil/luau-decompiler) - decompiler deobf
- Settings checkboxes respond on the first click without focusing an input box; disabled controls do not trigger changes and stale animations cannot overwrite the current check state.
