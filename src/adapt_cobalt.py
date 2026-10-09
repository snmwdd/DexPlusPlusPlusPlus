"""Adapt the supplied Cobalt bundle to Dex without changing its spy modules."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
source = (ROOT / "vendor/Cobalt.luau").read_text()
marker = re.compile(r'(?m)^    (?:\[\d+\] = )?function\(\)local wax,script,require,CreateLookupTable=ImportGlobals\((\d+)\)')


def replace_once(text, old, new):
    assert text.count(old) == 1, f"Expected one adaptation target: {old[:100]}"
    return text.replace(old, new, 1)


def change_module(identifier, transform):
    global source
    markers = list(marker.finditer(source))
    for index, item in enumerate(markers):
        if int(item[1]) == identifier:
            end = markers[index + 1].start() if index + 1 < len(markers) else source.index("local ObjectTree =", item.end())
            source = source[:item.start()] + transform(source[item.start():end]) + source[end:]
            return
    raise AssertionError(f"Missing Cobalt module {identifier}")


def entry(text):
    text = replace_once(text, "wax.shared.IS_ACTOR = false", "wax.shared.IS_ACTOR = false\nwax.shared.DexBridge.OnShared(wax.shared)")
    text = replace_once(text, "wax.shared.ScreenGui:Destroy()", "wax.shared.DexBridge.Unmount()")
    # Cleanup may run after a partially failed startup, before all tables exist.
    text = text.replace("pairs(wax.shared.Connections)", "pairs(wax.shared.Connections or {})")
    text = text.replace("table.clear(wax.shared.Connections)", "table.clear(wax.shared.Connections or {})")
    text = text.replace("in wax.shared.Logs do", "in wax.shared.Logs or {} do")
    text = text.replace("table.clear(wax.shared.Logs)", "table.clear(wax.shared.Logs or {})")
    text = text.replace("table.clear(wax.shared.IncomingLogConnectionFunctions)", "table.clear(wax.shared.IncomingLogConnectionFunctions or {})")
    text = replace_once(text, "wax.shared.Communicator:Destroy()", "if wax.shared.Communicator then wax.shared.Communicator:Destroy() end")
    return text


def interface(text):
    text = replace_once(text, '\tfor Key, Value in pairs(Properties or {}) do\n', '\tfor Key, Value in pairs(Properties or {}) do\n\t\tif Key == "DexRawText" or Key == "DexTextSource" then continue end\n')
    return replace_once(text, "\treturn Object\nend\n\nlocal function CreateIcon", "\twax.shared.DexBridge.StyleObject(Object, Properties or {})\n\treturn Object\nend\n\nlocal function CreateIcon")


def window(text):
    start = text.index('local ScreenGui = Interface.New("ScreenGui", {')
    end = text.index("wax.shared.ScreenGui = ScreenGui", start)
    text = text[:start] + "local ScreenGui = wax.shared.DexBridge.Gui\n" + text[end:]
    text = replace_once(text, "local MainFrame = Interface.New(\"Frame\", {\n\tAnchorPoint = Vector2.new(0.5, 0.5),", "local MainFrame = Interface.New(\"Frame\", {\n\tAnchorPoint = Vector2.new(0, 0),")
    text = text.replace("Position = UDim2.fromScale(0.5, 0.5),", "Position = UDim2.fromScale(0, 0),", 1)
    text = replace_once(text, "Size = UDim2.fromOffset(640, 420),", "Size = UDim2.fromScale(1, 1),")
    text = replace_once(text, "local MainFrame = Interface.New(\"Frame\", {", "local MainFrame = Interface.New(\"Frame\", {\n\tBackgroundTransparency = 1,")
    text = text.replace("\tParent = ScreenGui,", "\tParent = wax.shared.DexBridge.Mount,", 1)
    start = text.index("do\n\tResize.new({")
    end = text.index("--// Minimized", start)
    text = text[:start] + text[end:]
    start = text.index("--// Minimized")
    end = text.index("--// Sonner", start)
    text = text[:start] + text[end:]
    text = replace_once(text, "\tShowButton = ShowButton,\n", "")
    text = text.replace("Parent = ScreenGui,", "Parent = wax.shared.DexBridge.Overlay,")
    # Scale Cobalt contents and overlays, leaving Dex title/resize controls intact.
    text = replace_once(text, "Scale = Interface.New(\"UIScale\", {\n\t\tParent = wax.shared.DexBridge.Overlay,\n\t}),", "Scale = Interface.New(\"UIScale\", {\n\t\tParent = MainFrame,\n\t}),")
    text = replace_once(text, "--// ContextMenus", "wax.shared.DexBridge.BindScale(MainFrame, DPIHandler.Scale)\n\n--// ContextMenus")
    text = replace_once(text, "ContextMenuController.new(ScreenGui, {", "ContextMenuController.new(wax.shared.DexBridge.Overlay, {")
    return text


def topbar(text):
    text = replace_once(text, 'Text = "Cobalt",', 'Text = "spy",')
    text = replace_once(text, "\tShowButton: TextButton,\n", "")
    text = replace_once(text, "\tlocal ShowButton = props.ShowButton\n", "")
    text = replace_once(text, "\t\treturn Button, Image", "\t\twax.shared.DexBridge.AttachToolbarHint(Button, IconName)\n\t\treturn Button, Image")
    start = text.index('\ttable.insert(TopButtonData, {\n\t\tType = "Separator",')
    end = text.index("\tfor Order, Data in TopButtonData do", start)
    # Native Dex title controls own closing and minimizing.
    text = text[:start] + text[end:]
    start = text.index("\tDrag.Setup(MainFrame, TopBar, nil, {")
    end = text.index("\n\treturn {", start)
    # The surrounding Dex window owns dragging and reopening.
    text = text[:start] + text[end:]
    return text


def assets(text):
    start = text.index("function AssetManager.GetCustomFont(Name: string): Font")
    end = text.index("function AssetManager.GetImage", start)
    text = text[:start] + 'function AssetManager.GetCustomFont(Name: string): Font\n\treturn Font.fromEnum(Name == "IBMPlexMono" and Enum.Font.Code or Enum.Font.SourceSans)\nend\n\n' + text[end:]
    return text


def icons(text):
    text = replace_once(text, 'function Icons.GetIconData(Icon: string)\n', 'function Icons.GetIconData(Icon: string)\n\tif wax.shared.DexBridge.HasIcon(Icon) then return "Image", IconMappings.Image end\n')
    return replace_once(text, 'function Icons.SetIcon(Object: IconObject, Icon: string)\n', 'function Icons.SetIcon(Object: IconObject, Icon: string)\n\tif wax.shared.DexBridge.SetIcon(Object, Icon) then return end\n')


def checkbox(text):
    start = text.index('\tlocal CheckboxUI = Interface.New("TextButton", {')
    end = text.index('\n\tfunction Checkbox:Reset()', start)
    text = text[:start] + '''\tlocal Row = Interface.New("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = props.Parent,
    })
    local CheckboxUI = Interface.New("TextButton", {
        Text = Options.Text, TextSize = 16,
        TextColor3 = if Checkbox.Risky then ToggleTextRiskyColor else Color3.new(1, 1, 1),
        BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = Row,
    })
    local NativeCheckbox = wax.shared.DexBridge.CreateCheckbox(Row, Checkbox.Value, function(Value)
        Checkbox:SetValue(Value)
    end)
    local function UpdateToggleVisual(instant: boolean?)
        NativeCheckbox:SetState(Checkbox.Value)
    end
''' + text[end:]
    text = replace_once(text, 'if Result == false then return end', 'if Result == false then UpdateToggleVisual(true); return end')
    text = replace_once(text, '\t\tSettingSync.Save(Idx, NewValue)', '\t\tlocal Saved, SaveError = SettingSync.Save(Idx, NewValue)\n\t\tif not Saved then\n\t\t\tUpdateToggleVisual(true)\n\t\t\twax.shared.Sonner.error(tostring(SaveError))\n\t\t\treturn\n\t\tend')
    return replace_once(text, 'CheckboxUI.MouseButton1Click:Connect', 'CheckboxUI.Activated:Connect')


def filter_checkbox(text):
    start = text.index('\tlocal function CreateToggle(')
    end = text.index('\n\tlocal function CreateRow(', start)
    text = text[:start] + '''\tlocal function CreateToggle(Parent: GuiObject, Filter: CallFilter)
        local Toggle
        Toggle = wax.shared.DexBridge.CreateCheckbox(Parent, Filter.Enabled, function(Enabled)
            ActiveToggleAnimations += 1
            local Success, Error = pcall(Props.Manager.SetEnabled, Props.Manager, Filter.Id, Enabled)
            ActiveToggleAnimations -= 1
            if not Success or not Error then
                Toggle:SetState(Filter.Enabled)
                if not Success then wax.shared.Sonner.error(tostring(Error)) end
            end
            if DeferredFilters then
                local Filters = DeferredFilters
                DeferredFilters = nil
                Refresh(Filters)
            end
        end)
        Toggle.Gui.Position = UDim2.new(1, -42, 0.5, 0)
    end
''' + text[end:]
    # Localize summary labels before interpolating raw condition values.
    text = replace_once(text, 'return if Direction == "Any" then "任意方向" elseif Direction == "Outgoing" then "传出" elseif Direction == "Incoming" then "传入" else Direction', 'return wax.shared.DexBridge.Translate(if Direction == "Any" then "任意方向" elseif Direction == "Outgoing" then "传出" elseif Direction == "Incoming" then "传入" else Direction)')
    text = text.replace('{RemoteFields.GetText(Condition.Field)}', '{wax.shared.DexBridge.Translate(RemoteFields.GetText(Condition.Field))}')
    text = text.replace('{Operators.GetText(Condition.Operator, true)}', '{wax.shared.DexBridge.Translate(Operators.GetText(Condition.Operator, true))}')
    text = text.replace('{Operators.GetText(First.Operator, true)}', '{wax.shared.DexBridge.Translate(Operators.GetText(First.Operator, true))}')
    text = text.replace('table.insert(Parts, "全部参数")', 'table.insert(Parts, wax.shared.DexBridge.Translate("全部参数"))')
    text = text.replace('then "参数数量" else `参数[{First.Subject.Index}]`', 'then wax.shared.DexBridge.Translate("参数数量") else `{wax.shared.DexBridge.Translate("参数")}[{First.Subject.Index}]`')
    text = text.replace('` · {#Filter.Target.Conditions} 个远程对象条件`', '` · {#Filter.Target.Conditions} {wax.shared.DexBridge.Translate("远程对象条件")}`')
    text = text.replace('` · {#Filter.Conditions} 个条件`', '` · {#Filter.Conditions} {wax.shared.DexBridge.Translate("条件")}`')
    text = replace_once(text, 'Text = FormatSummary(Filter),', 'Text = FormatSummary(Filter), DexRawText = true, DexTextSource = function() return FormatSummary(Filter) end,')
    return replace_once(text, 'Text = TargetName,', 'Text = TargetName, DexRawText = Filter.Target.Type == "Instance",')


def raw_text(text):
    # Argument keys/values and generated code are always data, not UI prose.
    targets = [
        'Text = Options.Label or Index,', 'Text = typeof(Value),', 'Text = Text,',
        'Text = RemoteInstance.Name,', 'Text = `{Remote.Name} ({RemoteData.Type})`,',
        'Text = if IsBlockedCall then `{OriginText} (Blocked)` else OriginText,',
    ]
    for target in targets:
        text = text.replace(target, target + ' DexRawText = true,')
    return text


def raw_code(text):
    return text.replace('Interface.New("TextLabel", {', 'Interface.New("TextLabel", {DexRawText = true,')


def raw_log_name(text):
    return replace_once(text, 'local Name = Interface.New("TextLabel", {', 'local Name = Interface.New("TextLabel", {DexRawText = true,')


change_module(1, entry)
change_module(117, icons)
change_module(118, assets)
change_module(120, interface)
change_module(123, window)
change_module(139, filter_checkbox)
change_module(140, checkbox)
change_module(150, topbar)
for identifier in (142, 155, 161, 180):
    change_module(identifier, raw_text)
for identifier in (156, 158):
    change_module(identifier, raw_code)
change_module(181, raw_log_name)

# Replace neutral UI palette literals, including hover/selection tween targets.
# Colored status indicators and syntax highlighting retain their meaning.
ui_modules = {120, 123, 125, 126, 128, 129, 130, 131, 132, 133, 134, 135,
              136, 139, 140, 141, 142, 144, 145, 146, 147, 148, 149, 150,
              151, 153, 155, 156, 157, 158, 159, 160, 161, 162, 177, 179, 180, 181}


def palette(text):
    def neutral(match):
        red, green, blue = map(int, match.groups())
        if red != green or green != blue or red > 75:
            return match[0]
        key = "TextBox" if red <= 11 else "Main2" if red <= 21 else "Main1" if red <= 35 else "Button" if red <= 60 else "Highlight"
        return f"wax.shared.DexBridge.Theme.{key}"
    return re.sub(r"Color3\.fromRGB\((\d+),\s*(\d+),\s*(\d+)\)", neutral, text)


for identifier in sorted(ui_modules):
    change_module(identifier, palette)

source = replace_once(source, "local SharedEnvironment = {}", "local SharedEnvironment = {DexBridge = bridge}")
source = replace_once(source, "    Defer(LoadScript, ScriptRef)", "    LoadScript(ScriptRef)")
prefix = "-- Generated by src/adapt_cobalt.py from the user-supplied vendor/Cobalt.luau.\n-- Cobalt authors: deivid, upio. Original notices are preserved below.\nlocal function launch(bridge)\n"
suffix = "\nreturn SharedEnvironment\nend\nlocal module={InitDeps=function() end,InitAfterMain=function() end,Main=function() return {Launch=launch} end}\nif gethsfuncs then _G.moduleData=module else return module end\n"
(ROOT / "modules/CobaltRuntime.lua").write_text(prefix + source + suffix)
print("Generated CobaltRuntime.lua with Dex window and palette adapters")
