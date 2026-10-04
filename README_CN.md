# Dex# (DexPlusPlusPlusPlus)

![DevTool Dex#](https://img.shields.io/badge/DevTool-Dex++++-green)
![Roblox Luau](https://img.shields.io/badge/Roblox-Luau-blue)
![Lua Script](https://img.shields.io/badge/Lua-Script-black)

### Dex# 是 Dex 和 Dex++ 的扩展与定制版本

[![简体中文 Simplified Chinese](https://img.shields.io/badge/简体中文-Chinese-red?style=flat-square&labelColor=black)](https://github.com/snmwdd/DexPlusPlusPlusPlus/blob/main/README_CN.md)
[![English 英文](https://img.shields.io/badge/English-英文-blue?style=flat-square&labelColor=black)](https://github.com/snmwdd/DexPlusPlusPlusPlus/blob/main/README.md)

![预览](./image/截屏2026-10-04%2016.52.58.png)

[查看更多图片](./image.md)

## 最新版本脚本

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/snmwdd/DexPlusPlusPlusPlus/refs/heads/main/script.lua"))()
```

## Dex# 和 Dex++ 有什么区别？

Dex# 是基于 Dex++ 进行定制和扩展的版本。

在保留原有 Dex / Dex++ 功能的基础上，Dex# 增加了新的对象选择与编辑工具、语言切换、反编译器选项，并修复和优化了部分界面与兼容性问题。

### Dex# 新增 / 修复的功能

- 支持直接点击 GUI 对象进行选择
- 选择 GUI 后自动在 Explorer 中定位对应对象
- 为当前选中的 GUI 显示蓝色选择轮廓
- 为选中的 GUI 对象和 Part 增加移动、缩放和旋转工具
- GUI 支持可视化缩放控制点
- GUI 支持旋转控制
- 增加位置与尺寸辅助显示
- Part 支持原生三轴移动、缩放和旋转控制柄
- GUI 选择与编辑同时支持鼠标和触摸操作
- Settings 中加入 English / 中文语言切换
- 默认语言为英文
- 优化反编译器选择菜单，使界面更加紧凑
- 增加 ASCII 风格的 `Re-Deobf` 按钮
- 新增 `lua.expert/demo`
- 新增 [Luaunveil / luau-decompiler](https://github.com/Luaunveil/luau-decompiler)
- 同时保留以下反编译模式：
  - Konstant
  - AdvancedDecompiler
  - Shiny
  - Executor
- 改善 DataModel 根节点兼容性，解决部分情况下 Explorer 树为空的问题
- 优化 Script Viewer 工具栏在不同窗口尺寸下的布局
- 修复重复创建 Settings 窗口的问题
- 修复无效透明度数值导致的问题

> 除 `Executor` 模式外，其他反编译模式需要执行器支持 `getscriptbytecode`。

## 构建

1. 下载或克隆此仓库。
2. 确保电脑上已安装 Python 3。
3. 运行 `build.py`。
4. 构建完成后将生成 `out.lua`。

## Credits

- [Chillz](https://github.com/AZYsGithub) – Dex++ 维护者
- [Cazan](https://github.com/Cazzanos) – 协助开发 Model Viewer
- [Moon](https://github.com/LorekeeperZinnia/Dex) – 原始 Dex Explorer
- [Toon](https://github.com/Toon-arch) – 项目贡献者，以及 IY Dex 部分组件的来源
- [ChatGPT](https://chatgpt.com) – 协助代码开发、调试与文档整理
