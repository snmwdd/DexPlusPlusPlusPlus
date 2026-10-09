-- Scoped translation of Spy UI; raw remote names, arguments and code are excluded.
local Main,Settings
local function initDeps(data) Main,Settings=data.Main,data.Settings end
local english={
    ["远程对象条件"]="remote conditions", ["条件"]="conditions",
    ["标题"]="Title", ["完整支持"]="Full support", ["部分支持"]="Partial support",
    ["兼容性"]="Compatibility",
    ["未知"]="Unknown",
    ["记录 %s:%s 的远程通信失败：%s"]="Failed to log remote %s:%s: %s",
    ["启用修复"]="Enable fix",
    ["请重新加入游戏，使修复生效！"]="Rejoin the game for the fix to take effect!",
    ["此游戏可能采用当前执行器无法拦截的远程调用方式。启用兼容性修复并重新加入游戏后，即可尝试捕获这些调用。"]="This game may use remote calls that your executor cannot intercept. Enable the compatibility fix and rejoin to try capturing them.",
    ["验证失败"]="Validation failed",
    ["调用过滤器无效"]="Invalid call filter",
    ["包含"]="Contains",
    ["以…开头"]="Starts with",
    ["以…结尾"]="Ends with",
    ["类型"]="Type",
    ["名称"]="Name",
    ["类别"]="Class",
    ["完整路径"]="Full path",
    ["必须是支持的远程对象"]="must be a supported remote instance",
    ["只有参数条件才允许指定索引"]="Only argument conditions may specify an index",
    ["的值与所选操作符不兼容"]="has a value incompatible with the selected operator",
    ["包含相互冲突的条件"]="contains conflicting conditions",
    ["的操作符或值与字段不兼容"]="has an operator or value incompatible with the field",
    ["必须至少包含一个不冲突的远程对象条件"]="must contain at least one non-conflicting remote condition",
    ["函数地址"]="Function address",
    ["脚本路径"]="Script path",
    ["调用行号"]="Call line",
    ["来源 Actor"]="Source Actor",
    ["闭包类型"]="Closure type",
    ["匿名"]="Anonymous",
    ["匿名函数"]="Anonymous function",
    ["未命名插件"]="Unnamed plugin",
    ["未提供描述。"]="No description provided.",
    ["设置数据无效"]="Invalid settings data",
    ["加载设置失败："]="Failed to load settings:",
    ["界面缩放"]="UI scale",
    ["每页调用数量"]="Calls per page",
    ["传送后重新启动"]="Relaunch after teleport",
    ["重启后使用 RakNet Hook（实验性）"]="Use RakNet Hook after restart (experimental)",
    ["重启后使用 Oth Hook"]="Use Oth Hook after restart",
    ["捕获 Roblox 内部事件"]="Capture Roblox internal events",
    ["捕获 Actor 调用"]="Capture Actor calls",
    ["记录已拦截调用"]="Log blocked calls",
    ["忽略的远程对象类别"]="Ignored remote classes",
    ["自动忽略高频调用"]="Automatically ignore frequent calls",
    ["忽略 PlayerModule 调用"]="Ignore PlayerModule calls",
    ["显示执行器发起的调用"]="Show executor calls",
    ["实例路径生成方式"]="Instance path generation",
    ["无父级实例的定位方式"]="Unparented instance lookup",
    ["使用 buffer.fromstring()"]="Use buffer.fromstring()",
    ["在生成代码中添加 Cobalt 标头"]="Add Cobalt header to generated code",
    ["将调用保存到文件"]="Save calls to a file",
    ["跳过非必要的执行器检查"]="Skip nonessential executor checks",
    ["启用反作弊兼容性绕过"]="Enable anticheat compatibility bypass",
    ["<b>标题</b>"]="<b>Title</b>",
    ["说明"]="Description",
    ["编辑调用过滤器"]="Edit call filter",
    ["创建调用过滤器"]="Create call filter",
    ["选择 Cobalt 要匹配的远程调用及其条件。"]="Choose the remote calls and conditions to match.",
    ["取消"]="Cancel",
    ["保存修改"]="Save changes",
    ["创建过滤器"]="Create filter",
    ["此过滤器包含相互冲突的条件。"]="This filter contains conflicting conditions.",
    ["清空已捕获的调用？"]="Clear captured calls?",
    ["这将永久清除所有已捕获的传入及传出调用，且无法撤销。"]="This permanently clears all captured incoming and outgoing calls. This cannot be undone.",
    ["清空调用"]="Clear calls",
    ["鸣谢"]="Credits",
    ["<b>upio</b> · Cobalt 开发者"]="<b>upio</b> · Cobalt developer",
    ["<b>deivid</b> · Cobalt 开发者"]="<b>deivid</b> · Cobalt developer",
    ["关闭"]="Close",
    ["删除调用过滤器？"]="Delete call filter?",
    ["这将永久删除选中的调用过滤器。"]="This permanently deletes the selected call filter.",
    ["删除"]="Delete",
    ["已删除调用过滤器"]="Call filter deleted",
    ["暂无详细信息。"]="No details available.",
    ["检测风险"]="Detection risk",
    ["执行器不支持以下函数或库，可能导致 Cobalt 被游戏检测到：\n\n"]="Your executor does not support these functions or libraries, which may make Cobalt detectable by the game:\n\n",
    ["日志记录功能受限"]="Limited logging support",
    ["当前执行器无法完全支持 Cobalt 的远程调用记录。仍可捕获部分传入的 RemoteEvent（信息有限），但无法记录传出调用或传入的 RemoteFunction。"]="Your executor cannot fully support remote call logging. Some incoming RemoteEvents can be captured with limited information, but outgoing calls and incoming RemoteFunctions cannot be logged.",
    ["我已了解"]="Understood",
    ["当前执行器不支持 Oth Hook：\n\n"]="Your executor does not support Oth Hook:\n\n",
    ["警告"]="Warning",
    ["确定要关闭 Oth Hook 吗？此操作存在风险，在部分游戏中理论上可能导致账号被封禁。Cobalt 不对由此产生的封禁负责。更改将在下次启动 Cobalt 时生效。"]="Disable Oth Hook? This may increase detection risk and could result in a ban in some games. Cobalt is not responsible for resulting bans. This change takes effect on the next launch.",
    ["返回"]="Back",
    ["继续（长按确认）"]="Continue (hold to confirm)",
    ["当前执行器不支持 RakNet Hook：\n\n"]="Your executor does not support RakNet Hook:\n\n",
    ["确定要使用 RakNet Hook 吗？此功能存在风险，理论上可能导致账号被封禁。Cobalt 不对由此产生的封禁负责。更改将在下次启动 Cobalt 时生效。"]="Use RakNet Hook? This feature carries detection risk and could result in a ban. Cobalt is not responsible for resulting bans. This change takes effect on the next launch.",
    ["任意方向"]="Any direction",
    ["传出"]="Outgoing",
    ["传入"]="Incoming",
    ["符合条件的远程对象"]="Matching remotes",
    ["全部参数"]="All arguments",
    ["参数数量"]="Argument count",
    ["还没有创建任何调用过滤器。\n右键单击一条已捕获的调用即可创建。"]="No call filters yet.\nRight-click a captured call to create one.",
    ["编辑"]="Edit",
    ["复制副本"]="Duplicate",
    ["请选择…"]="Select…",
    ["无"]="None",
    ["全部移除"]="Remove all",
    ["已移除全部远程对象"]="All remotes removed",
    ["忽略匹配的调用"]="Ignore matching calls",
    ["拦截匹配的调用"]="Block matching calls",
    ["高亮匹配的调用"]="Highlight matching calls",
    ["且"]="AND",
    ["或"]="OR",
    ["当前远程对象"]="Current remote",
    ["远程对象"]="Remote",
    ["匹配远程对象时，至少需要设置一个条件。"]="Add at least one condition to match remotes.",
    ["添加远程对象条件"]="Add remote condition",
    ["参数数"]="Argument count",
    ["参数 1"]="Argument 1",
    ["参数 2"]="Argument 2",
    ["参数 3"]="Argument 3",
    ["添加条件"]="Add condition",
    ["加载中…"]="Loading…",
    ["未提供文本"]="No text provided",
    ["参数"]="Arguments",
    ["代码"]="Code",
    ["返回数据"]="Return data",
    ["调用代码"]="Call code",
    ["代码已复制到剪贴板"]="Code copied to clipboard",
    ["复制代码失败"]="Failed to copy code",
    ["拦截代码"]="Interceptor code",
    ["函数信息"]="Function information",
    ["C 闭包"]="C closure",
    ["Luau 函数"]="Luau function",
    ["函数信息已复制到剪贴板"]="Function information copied to clipboard",
    ["复制函数信息失败"]="Failed to copy function information",
    ["来源"]="Origin",
    ["远程对象路径"]="Remote path",
    ["已复制远程对象路径"]="Remote path copied",
    ["复制远程对象路径失败"]="Failed to copy remote path",
    ["已复制脚本路径"]="Script path copied",
    ["复制脚本路径失败"]="Failed to copy script path",
    ["反编译后的脚本"]="Decompiled script",
    ["已复制反编译脚本"]="Decompiled script copied",
    ["复制反编译脚本失败"]="Failed to copy decompiled script",
    ["反编译脚本失败"]="Failed to decompile script",
    ["事件"]="Event",
    ["重放"]="Replay",
    ["正在重放事件…"]="Replaying event…",
    ["事件重放成功！"]="Event replayed successfully!",
    ["重放事件失败"]="Failed to replay event",
    ["取消忽略"]="Stop ignoring",
    ["忽略"]="Ignore",
    ["已开始"]="Started",
    ["已停止"]="Stopped",
    ["取消拦截"]="Stop blocking",
    ["拦截"]="Block",
    ["清空日志"]="Clear logs",
    ["读取函数数据时发生错误。"]="An error occurred while reading function data.",
    ["插件"]="Plugins",
    ["暂无描述。"]="No description.",
    ["搜索日志…"]="Search logs…",
    ["全部"]="All",
    ["查看详情"]="View details",
    ["常规"]="General",
    ["清空已捕获调用"]="Clear captured calls",
    ["捕获"]="Capture",
    ["过滤"]="Filters",
    ["重置过滤设置"]="Reset filter settings",
    ["已将远程调用过滤设置恢复为默认值"]="Remote call filters reset to defaults",
    ["调用过滤器"]="Call filters",
    ["调用过滤器已更新"]="Call filter updated",
    ["已复制调用过滤器"]="Call filter duplicated",
    ["已忽略的远程对象"]="Ignored remotes",
    ["尚未忽略任何远程对象。"]="No ignored remotes.",
    ["已拦截的远程对象"]="Blocked remotes",
    ["尚未拦截任何远程对象。"]="No blocked remotes.",
    ["代码生成"]="Code generation",
    ["文件日志"]="File logging",
    ["已关闭文件日志"]="File logging disabled",
    ["已启用文件日志"]="File logging enabled",
    ["未在记录"]="Not logging",
    ["复制文件名"]="Copy filename",
    ["尚未开启文件日志"]="File logging is not enabled",
    ["复制会话名称失败"]="Failed to copy session name",
    ["会话名称已复制到剪贴板"]="Session name copied to clipboard",
    ["复制文件路径"]="Copy file path",
    ["复制日志路径失败"]="Failed to copy log path",
    ["日志路径已复制到剪贴板"]="Log path copied to clipboard",
    ["将会话导出为 HTML"]="Export session as HTML",
    ["当前执行器不支持 writefile"]="Your executor does not support writefile",
    ["正在排序调用…"]="Sorting calls…",
    ["正在开始导出…"]="Starting export…",
    ["兼容性与安全"]="Compatibility and safety",
    ["<b>完整支持</b>"]="<b>Full support</b>",
    ["<b>部分支持</b>（"]="<b>Partial support</b> (",
    [" 项检查未通过）"]=" checks failed)",
    ["这些设置将在下次启动 Cobalt 时生效。"]="These settings take effect on the next Cobalt launch.",
    ["关于与鸣谢"]="About and credits",
    ["Cobalt 及其依赖的开源项目。"]="Cobalt and its open-source dependencies.",
    ["查看鸣谢"]="View credits",
    ["复制调用代码"]="Copy call code",
    ["复制拦截代码"]="Copy interceptor code",
    ["复制远程对象路径"]="Copy remote path",
    ["复制脚本路径"]="Copy script path",
    ["调用过滤器已创建"]="Call filter created",
    ["时间："]="Time:",
    ["页码无效！"]="Invalid page number!",
}
local function main()
    local Localization={}
    function Localization.New()
        local entries={}
        local localizer={}
        local function englishEnabled()
            return Main.Localization.Normalize(Settings.Language)=="English"
        end
        local function translate(source)
            if not englishEnabled() then return source end
            if english[source] then return english[source] end
            -- Translate only recognized UI templates, preserving captured payloads.
            local index=source:match("^参数 (%d+)$")
            if index then return "Argument "..index end
            local templates={
                {"^已忽略 (.*)（(.*)），因为调用过于频繁。$", "Ignored %1 (%2) because calls are too frequent."},
                {"^Cobalt 已绕过 (.*)（检测到反作弊）$", "Cobalt bypassed %1 (anticheat detected)"},
                {"^时间：(.*)$", "Time: %1"},
                {"^执行器：(.*)$", "Executor: %1"},
                {"^兼容性：(.*)$", "Compatibility: %1"},
                {"^检测到反作弊：(.*)$", "Anticheat detected: %1"},
                {"^调用记录已成功导出至 (.*)$", "Calls exported to %1"},
                {"^导出失败：(.*)$", "Export failed: %1"},
                {"^已开始忽略事件$", "Started ignoring event"},
                {"^已停止忽略事件$", "Stopped ignoring event"},
                {"^已开始拦截事件$", "Started blocking event"},
                {"^已停止拦截事件$", "Stopped blocking event"},
            }
            for _,template in ipairs(templates) do
                if source:match(template[1]) then
                    source=source:gsub(template[1],template[2]); break
                end
            end
            -- Rich-text UI labels; tags are kept byte-for-byte.
            source=source:gsub("([^<>]+)",function(part)
                if english[part] then return english[part] end
                local failed=part:match("^（(%d+) 项检查未通过）$")
                if failed then return " ("..failed.." checks failed)" end
                return part
            end)
            return source
        end
        local function render(entry)
            if entry.Provider then entry.Source=entry.Provider() end
            entry.Rendered=entry.Raw and entry.Source or translate(entry.Source)
            entry.Object[entry.Property]=entry.Rendered
        end
        function localizer.Bind(object,raw,provider)
            if (raw and not provider) or entries[object] then return end
            local property
            if object:IsA("TextBox") then property="PlaceholderText"
            elseif object:IsA("TextLabel") or object:IsA("TextButton") then property="Text" end
            if not property then return end
            local entry={Object=object,Property=property,Source=object[property],Raw=raw,Provider=provider}
            entries[object]=entry
            entry.Change=object:GetPropertyChangedSignal(property):Connect(function()
                local value=object[property]
                if value==entry.Rendered then return end
                entry.Source=value
                render(entry)
            end)
            entry.Death=object.Destroying:Connect(function()
                entry.Change:Disconnect(); entry.Death:Disconnect(); entries[object]=nil
            end)
            render(entry)
        end
        function localizer.Refresh()
            for _,entry in pairs(entries) do render(entry) end
        end
        function localizer.Destroy()
            for _,entry in pairs(entries) do entry.Change:Disconnect(); entry.Death:Disconnect() end
            entries={}
        end
        localizer.Translate=translate
        return localizer
    end
    return Localization
end
local module={InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
