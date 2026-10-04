-- Dex# localization: only owned UI chrome is translated, never instance/API data.
local Main, Settings, Apps
local function initDeps(data) Main, Settings, Apps=data.Main,data.Settings,data.Apps end
local zh = {
    ["3D Preview"]="3D 预览",
    ["Basic Colors"]="基本颜色",
    ["Blue:"]="蓝：",
    ["ColorSequence Color Picker"]="颜色序列选择器",
    ["Custom Colors (RC = Set)"]="自定义颜色（右键设置）",
    ["Green:"]="绿：",
    ["Hue:"]="色相：",
    ["More Colors"]="更多颜色",
    ["Name"]="名称",
    ["Objects"]="对象",
    ["Red:"]="红：",
    ["Sat:"]="饱和度：",
    ["Save Instance - Error"]="保存实例 - 错误",
    ["Save Instance - Saved"]="保存实例 - 已保存",
    ["Save Instance - Saving"]="保存实例 - 正在保存",
    ["Type"]="类型",
    ["Val:"]="亮度：",
    ["Window"]="窗口",
    ["Your executor does not support 'writefile'"]="执行器不支持 writefile",
    ["[SETTING: OFF]"]="[设置：关闭]",
    ["[SETTING: ON]"]="[设置：开启]",
    ["- Select -"]="- 请选择 -",
    ["Error: Name begins with 'RBX'"]="错误：名称不能以 RBX 开头",
    ["Error: Name over 100 chars"]="错误：名称超过 100 字符",
    ["Failed to view model: No PrimaryPart is found."]="无法预览模型：未找到 PrimaryPart。",
    ["Language"]="语言",
    ["Settings"]="设置",
    ["Settings - Saving"]="设置 - 正在保存",
    ["Settings - Saved"]="设置 - 已保存",
    ["Explorer"]="资源列表",
    ["Properties"]="属性",
    ["Notepad"]="脚本编辑器",
    ["Console"]="控制台",
    ["Save Instance"]="保存实例",
    ["3D Viewer"]="3D 查看器",
    ["Click part to select"]="点击选择零件",
    ["Click gui to select"]="点击选择 GUI",
    ["Close"]="关闭",
    ["Move"]="移动",
    ["Scale"]="缩放",
    ["Rotate"]="旋转",
    ["UI"]="界面",
    ["Window Title On Middle"]="窗口标题居中",
    ["Background Transparency"]="背景透明度",
    ["Class Icons"]="类图标",
    ["Click to Rename"]="点击重命名",
    ["Part Selection Box"]="零件选择框",
    ["Use GetChildren to Copy Path"]="使用 GetChildren 复制路径",
    ["Show Deprecated"]="显示弃用属性",
    ["Show Hidden"]="显示隐藏属性",
    ["Show Attributes"]="显示属性标记",
    ["Clear On Focus"]="获得焦点时清空",
    ["Script Viewer"]="脚本查看器",
    ["Show Decompiled Script Info"]="显示反编译脚本信息",
    ["Decompiler"]="反编译器",
    ["Deobf Mode"]="反编译模式",
    ["Select a decompiler for View Script."]="选择查看脚本时使用的反编译器。",
    ["Non-Executor modes require getscriptbytecode."]="非 Executor 模式需要 getscriptbytecode。",
    ["Shiny Decompiler Port"]="Shiny 反编译器端口",
    ["Prefer Fallback Decompiler"]="优先使用备用反编译器",
    ["Restart"]="重启",
    ["Apply Current Settings"]="应用当前设置",
    ["By applying current settings requires reload.\nAny unsaved progress will be lost.\nAre you sure?"]="应用这些设置需要重新加载。\n未保存的内容将丢失。\n确定继续？",
    ["Apply Later"]="稍后应用",
    ["Apply Now"]="立即应用",
    ["Copy"]="复制",
    ["Copy to Clipboard"]="复制到剪贴板",
    ["Save"]="保存",
    ["Save to File"]="保存到文件",
    ["Dump Functions"]="导出函数",
    ["Execute"]="执行",
    ["Clear"]="清空",
    ["Re-Deobf"]="重新反编译",
    ["Cancel"]="取消",
    ["OK"]="确定",
    ["Yes"]="是",
    ["No"]="否",
    ["Reset"]="重置",
    ["Delete"]="删除",
    ["Cut"]="剪切",
    ["Paste"]="粘贴",
    ["Duplicate"]="复制实例",
    ["Rename"]="重命名",
    ["Group"]="分组",
    ["Ungroup"]="取消分组",
    ["Select Children"]="选择子项",
    ["Jump to Parent"]="跳到父级",
    ["Copy Path"]="复制路径",
    ["View Script"]="查看脚本",
    ["Save As"]="另存为",
    ["Color Picker"]="颜色选择器",
    ["NumberSequence Editor"]="数字序列编辑器",
    ["ColorSequence Editor"]="颜色序列编辑器",
    ["Search"]="搜索",
    ["Search workspace"]="搜索资源列表",
    ["Search properties"]="搜索属性",
    ["Filter"]="筛选",
    ["Refresh"]="刷新",
    ["Expand All"]="全部展开",
    ["Collapse All"]="全部折叠",
    ["Insert Object"]="插入对象",
    ["Insert Part"]="插入零件",
    ["Teleport To"]="传送至",
    ["Ultimate Debugging Suite"]="全功能调试工具",
    ["Contributors >>"]="开发者 >>",
    ["Toon (IY Dex and PRs)"]="Toon（IY Dex 与贡献）",
    ["Moon (Dex)"]="Moon（Dex）",
    ["Cazan (3D Preview)"]="Cazan（3D 预览）",
    ["Chillz (Original Dex)"]="Chillz（原版 Dex）",
    ["Gpt6.1 (Dex#)"]="Gpt6.1（Dex#）",
    ["Running"]="运行中",
    ["Initializing Library"]="初始化界面库",
    ["Fetching Roblox Version"]="获取 Roblox 版本",
    ["Fetching API"]="获取 API",
    ["Loading Modules"]="加载模块",
    ["Initializing Apps"]="初始化应用",
    ["Loading Plugin Files"]="加载插件文件",
    ["Complete"]="完成",
    ["Cannot edit this object"]="无法编辑此对象",
    ["Layout controls position"]="布局控制位置",
    ["Grid layout controls size"]="网格布局控制尺寸",
    ["AutomaticSize controls size"]="AutomaticSize 控制尺寸",
    ["Auto Scroll"]="自动滚动",
    ["AutoScroll"]="自动滚动",
    ["Find"]="查找",
    ["Replace"]="替换",
    ["Find Next"]="查找下一个",
    ["Remove Attribute"]="移除属性",
    ["Add Attribute"]="添加属性",
    ["Name:"]="名称：",
    ["Filename:"]="文件名：",
    ["File Name"]="文件名",
    ["Save Selected"]="保存选中对象",
    ["Save All"]="保存全部",
    ["Output"]="输出",
    ["Time"]="时间",
    ["Value"]="数值",
    ["Color"]="颜色",
    ["Envelope"]="范围",
}
local function main()
    local UI={}
    local roots, ignored={},setmetatable({}, {__mode="k"})
    local language="English"
    function UI.Normalize(value)
        return (value=="中文" or value=="Chinese" or value=="zh-CN" or value=="zh") and "中文" or "English"
    end
    function UI.Translate(source)
        if language~="中文" then return source end
        if zh[source] then return zh[source] end
        for _, pair in ipairs({{"Deobf: ","反编译： "},{"Initializing Plugin: ","初始化插件： "}}) do
            if source:sub(1,#pair[1])==pair[1] then return pair[2]..source:sub(#pair[1]+1) end
        end
        return source
    end
    function UI.Ignore(object) ignored[object]=true end
    local function skip(object)
        if object.Name=="PropName" or object.Name=="ValueBox" or object.Name=="LineNumbers" or object.Name=="OutputTemplate" then return true end
        local current=object
        while current do
            if ignored[current] or current.Name=="Lines" or current.Name=="Output" or current.Name=="BackgroundOutput" then return true end
            if object.Name=="EntryName" and Apps.Explorer and Apps.Explorer.Window and current==Apps.Explorer.Window.Gui then return true end
            current=current.Parent
        end
        return false
    end
    local function render(entry)
        if skip(entry.Object) then return end
        local text=UI.Translate(entry.Source)
        entry.Rendered=text
        if entry.Object[entry.Property]~=text then entry.Object[entry.Property]=text end
    end
    function UI.Track(root)
        if roots[root] then return end
        local state={Connections={},Entries={}}
        roots[root]=state
        local bound=setmetatable({}, {__mode="k"})
        local function bind(object)
            if bound[object] or skip(object) then return end
            local property
            if object:IsA("TextBox") then property="PlaceholderText"
            elseif object:IsA("TextLabel") or object:IsA("TextButton") then property="Text" end
            if not property then return end
            bound[object]=true
            local entry={Object=object,Property=property,Source=object[property]}
            state.Entries[#state.Entries+1]=entry
            state.Connections[#state.Connections+1]=object:GetPropertyChangedSignal(property):Connect(function()
                if skip(object) then return end
                local value=object[property]
                if value==entry.Rendered then return end
                entry.Source=value
                render(entry)
            end)
            render(entry)
        end
        bind(root)
        for _, object in ipairs(root:GetDescendants()) do bind(object) end
        state.Connections[#state.Connections+1]=root.DescendantAdded:Connect(bind)
        state.Connections[#state.Connections+1]=root.Destroying:Connect(function()
            for _, c in ipairs(state.Connections) do c:Disconnect() end
            roots[root]=nil
        end)
    end
    function UI.SetLanguage(value)
        language=UI.Normalize(value)
        Settings.Language=language
        for _, state in pairs(roots) do
            for _, entry in ipairs(state.Entries) do pcall(render,entry) end
        end
        return language
    end
    function UI.Init() UI.SetLanguage(Settings.Language) end
    function UI.Destroy()
        for _, state in pairs(roots) do for _, c in ipairs(state.Connections) do c:Disconnect() end end
        roots={}
    end
    return UI
end
local module={InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
