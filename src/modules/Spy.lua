-- Dex window adapter for the supplied Cobalt Spy by deivid and upio.
local Main,Lib,Apps,Settings
local function initDeps(data)
    Main,Lib,Apps,Settings=data.Main,data.Lib,data.Apps,data.Settings
end

local function main()
    local Spy={State="idle"}
    local window,mount,overlay,errorPanel,status,detail,shared,tooltip
    local connections={}
    local generation=0
    local destroying=false
    local launchThread
    local locale=Apps.SpyLocalization.New()

    local function new(class,parent,properties)
        local object=Instance.new(class)
        for key,value in pairs(properties or {}) do object[key]=value end
        object.Parent=parent
        return object
    end
    local function disconnect()
        for connection in pairs(connections) do pcall(function() connection:Disconnect() end) end
        connections={}
        locale.Destroy()
    end
    local function ignore(root)
        if Main.Localization then Main.Localization.Ignore(root) end
    end
    local function setStatus(text,errorText)
        status.Text=text
        detail.Text=errorText or ""
    end

    -- Apply transparency centrally so selected rows/hover states remain consistent.
    -- Neutral color literals are adapted at build time; status/syntax colors survive.
    function Spy.StyleObject(object,properties)
        local theme=Settings.Theme
        locale.Bind(object,properties.DexRawText,properties.DexTextSource)
        if object:IsA("UICorner") then
            object.CornerRadius=UDim.new(0,2)
            for _,key in ipairs({"TopLeftRadius","TopRightRadius","BottomLeftRadius","BottomRightRadius"}) do
                if properties[key] then pcall(function() object[key]=UDim.new(0,2) end) end
            end
        elseif object:IsA("GuiObject") then
            local isText=object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
            if isText then
                if not properties.FontFace and properties.Font~=Enum.Font.Code then
                    object.FontFace=Font.fromEnum(Enum.Font.SourceSans)
                end
                local color=object.TextColor3
                if color and math.abs(color.R-color.G)<.01 and math.abs(color.G-color.B)<.01
                    and (color.R<.1 or color.R>.95) then object.TextColor3=theme.Text end
                if object:IsA("TextBox") then object.PlaceholderColor3=theme.PlaceholderText end
            end
            if object.BackgroundTransparency<.5 then
                local color=object.BackgroundColor3
                if not properties.BackgroundColor3 or (color.R>.95 and color.G>.95 and color.B>.95) then
                    object.BackgroundColor3=object:IsA("GuiButton") and theme.Button or theme.Main2
                end
            end
            local updating=false
            local function opacity()
                if updating then return end
                local value=object.BackgroundTransparency
                if value<.25 then
                    updating=true; object.BackgroundTransparency=.25; updating=false
                end
            end
            opacity()
            local connection=object:GetPropertyChangedSignal("BackgroundTransparency"):Connect(opacity)
            local death
            death=object.Destroying:Connect(function()
                connection:Disconnect()
                if death then death:Disconnect() end
                connections[connection]=nil
                if death then connections[death]=nil end
            end)
            connections[connection]=true
            connections[death]=true
        end
    end

    local function unmount()
        generation=generation+1
        local thread=launchThread
        launchThread=nil
        if thread and thread~=coroutine.running() then pcall(task.cancel,thread) end
        shared=nil
        Spy.State="idle"
        disconnect()
        if destroying then return end
        if tooltip then tooltip:Destroy(); tooltip=nil end
        mount:ClearAllChildren()
        overlay:ClearAllChildren()
        mount.Visible=false
        errorPanel.Visible=true
        setStatus("Spy could not start. Reload Dex to retry.")
        if not window.Closed then window:Hide() end
    end

    local function attachToolbarHint(button,icon)
        local names={settings="Spy Settings",search="Search Calls",info="Remote Details",puzzle="Spy Plugins"}
        local text=names[icon]
        if not text then return end
        local function hide() if tooltip then tooltip.Visible=false end end
        connections[button.MouseEnter:Connect(function()
            if not tooltip then
                tooltip=new("TextLabel",window.Gui,{Name="SpyToolbarHint",Visible=false,
                    Size=UDim2.new(0,180,0,24),BackgroundColor3=Settings.Theme.Menu,BackgroundTransparency=.15,
                    BorderSizePixel=0,Text="",Font=Enum.Font.SourceSans,TextSize=14,TextColor3=Settings.Theme.Text,ZIndex=10001})
            end
            local pos=button.AbsolutePosition
            tooltip.Text=text
            tooltip.Position=UDim2.new(0,math.max(0,pos.X-140),0,math.max(0,pos.Y-26))
            tooltip.Visible=true
        end)]=true
        connections[button.MouseLeave:Connect(hide)]=true
        connections[button.MouseButton1Click:Connect(hide)]=true
    end

    local function bindScale(mainFrame,scale)
        local overlayScale=new("UIScale",overlay,{Scale=scale.Scale})
        local function update()
            local value=math.max(.5,tonumber(scale.Scale) or 1)
            mainFrame.Size=UDim2.new(1/value,0,1/value,0)
            overlay.Size=UDim2.new(1/value,0,1/value,0)
            overlayScale.Scale=value
            window.MinX=math.max(585,math.floor(585*value))
            window.MinY=math.max(240,math.floor(220*value)+20)
        end
        update()
        connections[scale:GetPropertyChangedSignal("Scale"):Connect(update)]=true
    end

    -- Called synchronously by Main.Init while the existing Dex intro is visible.
    function Spy.Start()
        if destroying or Spy.State=="loading" or Spy.State=="running" then return false end
        local globals=getgenv and getgenv() or _G
        if globals.CobaltInitialized or globals.Cobalt then
            Spy.State="error"
            errorPanel.Visible=true
            setStatus("Another Cobalt instance is already running. Unload it before starting Dex Spy.")
            return false
        end
        generation=generation+1
        local request=generation
        Spy.State="loading"
        errorPanel.Visible=false
        mount.Visible=false
        local bridge={Gui=window.Gui,Mount=mount,Overlay=overlay,Theme=Settings.Theme,
            StyleObject=Spy.StyleObject,BindScale=bindScale,Unmount=unmount,
            CreateCheckbox=Spy.CreateCheckbox,HasIcon=Spy.HasIcon,SetIcon=Spy.SetIcon,
            AttachToolbarHint=attachToolbarHint,Translate=locale.Translate,
            OnShared=function(value) shared=value end,
        }
        launchThread=coroutine.running()
        local ok,result=pcall(Apps.CobaltRuntime.Launch,bridge)
        launchThread=nil
        if request~=generation or destroying then return false end
        if not ok then
            local failed=shared
            if failed and failed.Unload then pcall(failed.Unload) end
            if failed then failed.Unloaded=true end
            disconnect()
            mount:ClearAllChildren(); overlay:ClearAllChildren()
            shared=nil; Spy.State="error"
            errorPanel.Visible=true; mount.Visible=false
            setStatus("Spy could not start. Reload Dex to retry.",tostring(result))
            warn("[Dex spy] "..tostring(result))
            return false
        end
        shared=result
        Spy.State="running"
        mount.Visible=true
        return true
    end

    function Spy.Destroy()
        if destroying then return end
        destroying=true
        Spy.Unload()
        window.Gui:Destroy()
    end

    function Spy.RefreshLanguage()
        locale.Refresh()
    end

    function Spy.CreateCheckbox(parent,value,callback)
        local checkbox=Lib.Checkbox.new(1)
        checkbox.Gui.AnchorPoint=Vector2.new(1,.5)
        checkbox.Gui.Position=UDim2.new(1,0,.5,0)
        checkbox.Gui.Parent=parent
        checkbox:SetState(value)
        checkbox.OnInput:Connect(function() callback(checkbox.Toggled) end)
        return checkbox
    end

    local miscIcons={copy="Copy",clipboard="Paste",["clipboard-copy"]="Copy",trash="Delete",["trash-2"]="Delete",
        pencil="Rename",["pencil-line"]="Rename",save="Save",play="Play",pause="Pause",["rotate-ccw"]="Undo",
        undo="Undo",redo="Redo",plus="InsertObject",["chevron-down"]="Expand",["chevron-up"]="Collapse",
        ["chevron-right"]="Collapse",code="ViewScript",["file-code"]="ViewScript",route="Reference",
        ["square-function"]="CallFunction",["arrow-up-right"]="JumpToParent",["corner-down-right"]="CallRemote"}
    local largeIcons={settings="Properties",info="Watcher",puzzle="Object",file="Book",["file-clock"]="Book",
        ["file-search"]="Script_Viewer",folder="Explorer",book="Book",["book-open"]="Book",terminal="Executor"}
    local nativeAssets={x="rbxassetid://5054663650",minus="rbxassetid://5034768003",check="rbxassetid://6401617475",
        search="rbxassetid://5034718129"}
    function Spy.HasIcon(icon)
        return miscIcons[icon]~=nil or largeIcons[icon]~=nil or nativeAssets[icon]~=nil
    end
    function Spy.SetIcon(object,icon)
        if not Spy.HasIcon(icon) then return false end
        if miscIcons[icon] then Main.MiscIcons:DisplayByKey(object,miscIcons[icon])
        elseif largeIcons[icon] then Main.LargeIcons:DisplayByKey(object,largeIcons[icon])
        else object.Image=nativeAssets[icon]; object.ImageRectOffset=Vector2.new(0,0); object.ImageRectSize=Vector2.new(0,0) end
        return true
    end

    function Spy.Unload()
        local runtime=shared
        if runtime and runtime.Unload then
            local ok=pcall(runtime.Unload)
            if not ok then runtime.Unloaded=true; unmount() end
        else
            if runtime then
                runtime.Unloaded=true
                for _,connection in pairs(runtime.Connections or {}) do pcall(function() connection:Disconnect() end) end
            end
            unmount()
        end
    end

    function Spy.DrawIcon(icon)
        icon.Image=""
        local color=Settings.Theme.Text
        for _,rect in ipairs({{.05,.45,.22,.1},{.25,.2,.1,.35},{.3,.2,.25,.1},
            {.52,.2,.1,.6},{.57,.7,.2,.1},{.75,.45,.1,.35},{.8,.45,.15,.1}}) do
            new("Frame",icon,{BackgroundColor3=color,BorderSizePixel=0,
                Position=UDim2.new(rect[1],0,rect[2],0),Size=UDim2.new(rect[3],0,rect[4],0)})
        end
    end

    function Spy.Init()
        window=Lib.Window.new(); Spy.Window=window
        window:SetTitle("spy")
        -- Cobalt dialogs rely on their parent layer; Global flattens their
        -- child ZIndex values below main-page rows and resize handles.
        window.Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        window:Resize(740,480)
        window.MinX,window.MinY=585,240
        window.Alignable=false
        window.GuiElems.Content.BackgroundColor3=Settings.Theme.Main2
        window.GuiElems.Content.BackgroundTransparency=.3
        window.GuiElems.TopBar.BackgroundColor3=Settings.Theme.Main1
        window.GuiElems.TopBar.BackgroundTransparency=.25
        mount=new("Frame",window.GuiElems.Content,{Name="CobaltMount",Visible=false,Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,BorderSizePixel=0})
        overlay=new("Frame",window.Gui,{Name="CobaltOverlay",Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,BorderSizePixel=0,ZIndex=10})
        -- Remote names, code previews and user inputs must retain their exact text.
        ignore(mount); ignore(overlay)
        -- Only startup errors need a pane; loading uses the normal Dex intro.
        errorPanel=new("Frame",window.GuiElems.Content,{Visible=false,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1})
        status=new("TextLabel",errorPanel,{BackgroundTransparency=1,Position=UDim2.new(0,20,0,20),
            Size=UDim2.new(1,-40,0,64),Text="",TextWrapped=true,Font=Enum.Font.SourceSans,TextSize=16,
            TextColor3=Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left})
        detail=new("TextLabel",errorPanel,{BackgroundTransparency=1,Position=UDim2.new(0,20,0,92),
            Size=UDim2.new(1,-40,1,-112),Text="",TextWrapped=true,Font=Enum.Font.Code,TextSize=13,
            TextColor3=Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top})
        ignore(detail)
        -- Parent before launch for layout measurements, but keep the GUI hidden.
        window.Gui.Enabled=false
        Main.SecureGui(window.Gui)
        window.OnActivate:Connect(function() window.Gui.Enabled=true end)
        window.OnDeactivate:Connect(function() if tooltip then tooltip.Visible=false end end)
        window.OnMinimize:Connect(function()
            overlay.Visible=false
            if tooltip then tooltip.Visible=false end
        end)
        window.OnRestore:Connect(function() overlay.Visible=true end)
        window.Gui.Destroying:Connect(function()
            if not destroying then destroying=true; Spy.Unload() end
        end)
        setStatus("Spy could not start. Reload Dex to retry.")
    end
    return Spy
end
local module={InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
