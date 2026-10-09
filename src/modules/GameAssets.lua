-- Live game resources used by File Manager. No external asset downloads required.
local Main, Apps, env
local function initDeps(data) Main,Apps,env=data.Main,data.Apps,data.env end
local IMAGE_PROPERTIES={
    Decal={"Texture"},Texture={"Texture"},ImageLabel={"Image"},ImageButton={"Image"},
    MeshPart={"TextureID"},SpecialMesh={"TextureId"},ParticleEmitter={"Texture"},Beam={"Texture"},Trail={"Texture"},
    SurfaceAppearance={"ColorMap","MetalnessMap","NormalMap","RoughnessMap"},
    MaterialVariant={"ColorMap","MetalnessMap","NormalMap","RoughnessMap"},
    Sky={"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"},
    Shirt={"ShirtTemplate"},Pants={"PantsTemplate"},ShirtGraphic={"Graphic"},
}
local function main()
    local Assets={}
    local function hiddenRoot()
        local getter=env.gethui or gethui
        if type(getter)~="function" then return end
        local ok,root=pcall(function()
            local value=getter()
            if value and not value:IsA("CoreGui") and not value:IsA("PlayerGui") then return value end
        end)
        if ok then return root end
    end
    local function excluded(object,hidden)
        local current=object
        while current and current~=game do
            if current==hidden or current==Main.MainGui or (Main.GuiPickerOwnRoots and Main.GuiPickerOwnRoots[current]) then return true end
            if Apps.Explorer and current==Apps.Explorer.SelectionVisualsHolder then return true end
            if Main.TransformTools and Main.TransformTools.IsOverlayRoot and Main.TransformTools.IsOverlayRoot(current) then return true end
            current=current.Parent
        end
        return false
    end
    function Assets.IsLive(entry)
        local hidden=hiddenRoot()
        local ok,result=pcall(function() return entry and entry.Object and entry.Object:IsDescendantOf(game) and not excluded(entry.Object,hidden) end)
        return ok and result==true
    end
    function Assets.Scan(filter, cancelled)
        local ok,objects=pcall(function() return game:GetDescendants() end)
        if not ok then return nil,"Cannot scan game resources" end
        local hidden=hiddenRoot()
        local entries={}
        for index,object in ipairs(objects) do
            if cancelled and cancelled() then return nil,"Resource scan cancelled" end
            pcall(function()
                if excluded(object,hidden) then return end
                local class=object.ClassName
                local path=object:GetFullName()
                if filter~="Images" and (object:IsA("Model") or object:IsA("MeshPart")) then
                    entries[#entries+1]={Name=object.Name,Path=path,Object=object,Kind="Model",Class=class}
                end
                if filter~="Models" then
                    for _,property in ipairs(IMAGE_PROPERTIES[class] or {}) do
                        local readable,value=pcall(function() return object[property] end)
                        if readable and type(value)=="string" and value~="" then
                            entries[#entries+1]={Name=object.Name.." · "..property,Path=path.."."..property,
                                Object=object,Kind="Image",Property=property,Content=value,Class=class}
                        end
                    end
                end
            end)
            if index%500==0 then task.wait() end
        end
        table.sort(entries,function(a,b) return a.Path<b.Path end)
        return entries
    end
    function Assets.SetContent(entry,value)
        if not Assets.IsLive(entry) or not entry.Property then return nil,"Resource is no longer available" end
        if type(value)~="string" or #value>2048 then return nil,"Invalid asset ID or path" end
        if value:match("^%d+$") then value="rbxassetid://"..value end
        local ok=pcall(function() entry.Object[entry.Property]=value end)
        if not ok then return nil,"Cannot edit this resource" end
        entry.Content=value
        return true,value
    end
    function Assets.Copy(entry)
        if not Assets.IsLive(entry) then return nil,"Resource is no longer available" end
        if type(env.setclipboard)~="function" then return nil,"Clipboard is unavailable" end
        local readable,content=pcall(function()
            return entry.Property and tostring(entry.Object[entry.Property]) or Apps.Explorer.GetInstancePath(entry.Object)
        end)
        if not readable or type(content)~="string" then return nil,"Resource is no longer available" end
        local value=content:match("^rbxassetid://(%d+)$") or content:match("[?&]id=(%d+)") or content
        local ok=pcall(env.setclipboard,value)
        return ok or nil,ok and "Copied resource ID or path" or "File operation failed"
    end
    function Assets.Locate(entry)
        if not Assets.IsLive(entry) then return nil,"Resource is no longer available" end
        local ok,result=pcall(Apps.Explorer.SelectObject,entry.Object)
        return (ok and result) or nil,"Resource is no longer available"
    end
    function Assets.Remove(entry)
        if not Assets.IsLive(entry) then return nil,"Resource is no longer available" end
        if entry.Property then return Assets.SetContent(entry,"") end
        if entry.Kind~="Model" then return nil,"Cannot edit this resource" end
        local ok=pcall(function() entry.Object:Destroy() end)
        return ok or nil,"Cannot edit this resource"
    end
    function Assets.Export(entry,path)
        if not Assets.IsLive(entry) or entry.Kind~="Model" then return nil,"Select a model to export" end
        if type(env.saveinstance)~="function" then return nil,"File operation unavailable" end
        local ok=pcall(env.saveinstance,entry.Object,path,{Decompile=false,RemovePlayerCharacters=false})
        return ok or nil,ok and "Model exported" or "File operation failed"
    end
    return Assets
end
local module={InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
