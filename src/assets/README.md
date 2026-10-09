# File manager icons

`FileManagerIcons.svg` is the editable source; `FileManagerIcons.png` is the 32 px grayscale sprite atlas embedded in the FileManager module. Runtime does not download icon images.

The Lua logo geometry comes from [Simple Icons Lua](https://github.com/simple-icons/simple-icons/blob/develop/icons/lua.svg), distributed under [CC0](https://github.com/simple-icons/simple-icons/blob/develop/LICENSE.md). Other symbols are drawn for this project.

Executors with `getcustomasset` or `getsynasset` load the embedded PNG from `dex/assets/filemanager_icons_v2.png`. Otherwise the module draws monochrome GUI shapes, including a Lua emblem, so file icons remain visible.

When updating the SVG, rasterize it to PNG and update `ICON_ATLAS_BASE64` in `src/modules/FileManager.lua`. The normal Lua build embeds this string, so distributing `script.lua` is sufficient.
