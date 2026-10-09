-- Executor Workspace file browser and text editor, using Dex's window system.
local Main, Lib, Settings, env, Apps
local function initDeps(data)
    Main, Lib, Settings, env, Apps = data.Main, data.Lib, data.Settings, data.env, data.Apps
end

-- Grayscale SVG icons rasterized into one embedded PNG. Lua mark: Simple Icons.
local ICON_ATLAS_BASE64 = "iVBORw0KGgoAAAANSUhEUgAAAkAAAAAgCAYAAAD68cdFAAAACXBIWXMAAAsTAAALEwEAmpwYAAANZ0lEQVR4nO1dC6wdRRle3xox8YGiWEFRAY0oikJR4yNoxBiDIkbbghGjLVZFxUchYjQaDRpLiLamUUATjdGrFmI0QYyWJqWi3nvP/v/sbXMrWoN9aC1EKbT2cuk13/WfZrrdPWcfM7t7zvm/ZNLtubvz2MfMN9/8/z9RpFAoFAqFQqFQKBQKhUKhUCgUCoVCoVAoFAqFQqFQKBRjgsnJyccYY54/PT39wl6v91xmPpOIlhDRWdu2bXuWMeZlCwsLj7DnE9HriOh2Zp4ios9OTEw8qt0WKBQKhUIx/GDmryNFowwiWsvMfxmUiOhGEJQQddi5c+fjZ2ZmTgXxKVDfJUmSvDhJkhcw80FmXrAJJChE/UYZXXj+CoVifFC0zymTkKfPOmLyzcwTks7sSvvJczv7gZlnkaJRhjRybsCNnxOCsdH3ILh9+/YnMfM56d+3bt36BGY+DQnH6b8T0Sdc8iP1+1M0ItixY8fjjDHPAdmL4/gZoRh628+/K2DmpzDzFUR0CzNPIqG9+A1/6+IgQEQbfD+PfvVqsvNVjK4CULDPKZPmfA3U09PTT2fm9cz8kDO24Hg9/tZy++eaJCTjRIBmC5xjScYvMTh7KvtNbgcuZOhqGXyOOGUeAblh5jVJkpyAc+M4fl+aADHzbZEnoF7M/F2kpgZ93Fdm/gAz/5aIDqXI3R5m/r4x5lU+X9A2n39XICTnPmnjPO613O95afO9zLzSc5luJzhXokNcPFfq552U9umcG+18Fe0j1ADoO18f+SVJ8lgi+jgz/1v6gUljzBuZ+XwiulO+tQNE9MWsCXkT9eWGCYkSoGNvxF9lRuyl052amjrZ/X8cx+9i5n0ZpCat8vyDmd+BZTNmnnb+9qAx5jWRB6Bttq1NKR9EdAER/U3K+y8R/Y6Z1zHz15j5e0S03WnrhMxUmiRA3p5/EfUjhLqRBWa+Qe7p35l5VZIkT7V/w7GQo11yzvUeyz1638s8R3uu+47iXoWoV5HfQwMKRMjl1yr5y72/cdTtI7pGgDDpJaI7kIwxl/moJ2xKmfnd6N+cfmCla09a5JxRIUB8rBKOSfihIEr4oIGema/zVpifATDd6VZWAhYWFh4Jw2Yn/6tcxSeH+NxNRN9i5h8JQfgkSBA+BGa+EsbTUQDy0wQJIqLV0v4HiehadxBOnfcK3Hep004hjLPD9vwHScCh1I004jj+sJRz57Zt256Wd97k5OSJRLRV7vvKLhAgR6XcVfUdyCGieWrUcb8T0Z9DkwAiuinku1A2/9Q3cFPUIkITsS4RIKv4E9H9SPItXlqnnmXVnTyVqEK5sxXrG9QoOa2Ey9LfQ0GU8AIEqBESVGYAxLGPmWccxy+xx8aYiweRH2be7L6YRLQUJAhKkP0tSZJToppItW2jMH6vylcaRLRM2o8B5Ywi1zDzR4noYbk3jREgX89/UJmpMvaEMA6UmQ4+9l39yI9TpxOZeTc6gV6v9+QyZYUiQGWvzSNA8i3Nl7BFmJdJSHAC5It0+8g/dF3KoAki1iUCJMrP/VC+YRMphGVTjfy+WdW+J20nhLyGfWmJM5RwW88gSnhBAlQ4NTAAHp39EdE9VQdfyInw5HJsfv45qG1ZLJuIfozlMGsTBA8yMPSoIrI6N9/KR0YblshsYh8MnsvM1mXQapIAeXn+RcuUe74hlHGgVX/wsYe8pssEKDW4HCh6PjM/YAefJtAFEtRh8hOsLl0kQCA/zHxSXQLk2DXWJkAVy57tindYnhKeVpy8KuHDRID6SOWlP44kSc52yl5TsH0vzaj3+rTre9VlsLwOpY/y4aXTYeZvS36XDDo37+Oo65nT9PMvWmbo/ORZzuctN2YBnYMobz+L/BOgMkbQvgkQ1vsXii4BWTU0ahBtkqBxJD9dI0BY7nKWqg7I8fIa+c0S0X7x+ERe/4EDTr8lMPFMvlrOXVwCkzy8ECBuwTusNSV8mAiQz+sQ0NAei2fXwLYR0ZfcPOI4fqLYwOBvf3TyK7SEVLRDSbfRZ+cjH9NBIuq5wR2bRhsGeV0gQAieiQ+5bFlEtBcdX9nr+tW5zMwvvezkiQDdjHfahltIz/zc/8sMHO//zVHDaIMEjSv56RoBkusuheojaXmd/Ow1dY2g65QdFfy9an6dVsLHlQBZ42cYMDu2P7vwUvdpH6TGLyMSNFzniWiLQ46O2I4gjuPn+TSCzGqjr7X3OI4vlDZcE7WIMSZAmL3tKVsWll19xJvydQ88EaC1QoBOz8ozRdbOkHf/G1ELaJgEbQxp/1ejXo0QsaYJkBANqOLr4SgTsp7pa7LUHWPMG5D6qUTDToCoLSW8iwRo0EzUnX3WIEBLLFlxSMwWLGVVbbslPgga6NMNNq+NPrwv4MUmbb8gahFteCQEIECl69KlJbC284HnoXxH52Xlmeojlsp7+7maZdaxd7A2aEGUqCbCYJRxv0+TMh91KXj/B8anqmII38cGxg1u+5W6+VW5pmwgxGEjQHT8c4czw3zR5+g4Tiw6QlR+D8aVAFmSUoAAfUH+hjgEXxXPE7iLX8LMl7svKPYNc8lV12dAgLQp076pSZRto8fo01XVIy+uoOLVgPt/RdFr8P7JNbVdQdP3oOQy2FrPBOgjQoAuzMoz1Ue8Vb7L1WNEgLwrLkXd70OQny4SoF6vdy4RHYZpA8wCZHVgRY5CtG5QflXqkLEVxj5JuVthDDsBov97cyoBCnnTXVi1xl0CyyFA75R/H8CHwMz/YuafyvnvZ+Ydcvyw7ZywRFa2PiHaWDDva6R954fIPyABqn1PurB8BgM+iWuxC4Z9g87H7E8iRO/37QZf0gAyhBH0MvmWlhUgQMuFLL03agGjsgQ2DJ5nTS2BiSEuiM9hECF4xMLWTia/S3MUohUhCZDPc9LQJbCOKkBNXGftDAAYMA8iQBL0agUGKxhfEdFn4jh+rRMZ+a4sA+uuEyBjzHukfR+qk48w+sqKyLgSIMlrpTyDrf1IkMjiu0VtXOWp7Eru7FWvK2KPBiVoUBmIQSUE6C1Rwxg1I+iue541QYAkLMqiFyIITirWGwjQXhCilEK0HylJkmdWracSoJaV8HFdAnNd1UFmLAFCNGdxx7tPdnl/sxid/UII0E8kEvRBkeETXGuM+bTNL47jl0fDswS2RPY4u6VqHiB8sjT4q6p5jDMBkvyul29oNwi26woqcS9W28jUPpWAjhGg86Rt1w4qg5k/L0Tw3KhBjKobfJc9z5ogQFbVQT+Y9oaVfh99ZM9ViGRFAN/jrUNMgOZ8jal1nlNrSvi4EiAEK0TQQjk+QaTOu2U2btOtRHS77P3yQ2wCioCB4n73MSL6OTN/Bw8CLvHIq9frPdu3O3lIAiT5/wYExlXFSl5/nbt04buNmzZtejQRXSQuoIvJ2SjU/e0inOujzCbKTwMqnHQCi0uqtgwbbVs+9lU+B6WOEaDTpV1rCxCgRcJov+EmMOqBELvqeRaaALmqTt4+UzCGdiYfRxUijBF2KawGCall3+PYCZUqm5xxtm0C1E8JT9tbihL+ezn3g1XL6ywBauI6YGZm5lR7jMHL2dahcMI1cRy/PWt7jWEhQHCxFDuozWUHcNkXDFb4ps7g36+Njqv+wGQNaOuW2UT5WcBsBnEt4OElbq+TcrzSznR8DoIdI0DHxPbpFwcoHTNoHMhPE3VpYwPmlgnQblfVGbBv5AZxjT86wcXyl10Kk90EZitu/VDawyvDU+yGMmXnoS0ClKeE23zTSnjd4LvRuBMg2cn9lfb/2GCuDAmSc690rj8rRDDB0AQIkI8bbfpB0Q7PGPMiiZ102Bjz6jrlqwJUDp43hO0EAZI2FVqOtTPvpgbncdoM1YbXKLs7/ZASoONUnQr52KWwhRCboabb72sz1C4SoCwl3G6G6irhtZUfp9JjS4Ds8pe7d5coQXsLkJ89rvIDTE1NnRwFQBMECPeAmW+Ttm3pp2SJG+jlYic1b4y5rOk2eppt9PV46uda28QzaYIEdYkAATIA3FGg/M1wTIgaQpl4OU3lH3oX9q4gJAGCgXNa1akC2IVKXpXqWSTKc5Fo0aNAgDKU8EOSjlHCRwpt3vR0EECQIhg1M/Mf3B3i5fguZv6UtflxGHmwQIJNDbZCgtZZ5g2jZrF3ej0znwPCh+1AxFZqQUICvM1H2W0QoDK2ZiHK94G6SkAGCRwYcyXnvMr7ALlAbB03sFmfZ4O4IffULU/RfYS2AepSfnn7fJXdL2zYCVAX+9qgGDQbLxqPpCqg3tjtMVxgVo0Ah0hZM2wsodmd4EPBV9C9kpLsr6Hu5Khf92ILgjLRi6s8/y4TkLbL96UE1AkE2C8wYlUUrU+VwHeK4USo/q/GmBN0LKoSCXqUxuIu97XBUDMia31jKJEhsfRTJJIzPFaSJDkFdkTRiIKZTzLGXMzMVzHzGsReQeyjEO6wWc9/AAFqlBR2rXyFQlEPPsm/77Eo5eE1ISnXU2zUxuKxI0BdAohQkiRnw8IfW0SAEMHgF15j4qp7WheMAxUKhUKhGGWwTjYVCoVCoVAoFAqFQqFQKBQKhUKhUCgUCoVCoVAoFIpo3PE/nlcJbhOZDYIAAAAASUVORK5CYII="
local ICONS = {Folder=0, File=1, Lua=2, Up=3, Refresh=4, NewFile=5, NewFolder=6, Search=7, Save=8, Delete=9, Open=10, Cancel=11, Confirm=12, Create=13, Image=14, Model=15, Copy=16, Locate=17}
local function decodeBase64(source)
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup={}
    for i=1,#alphabet do lookup[alphabet:sub(i,i)]=i-1 end
    local output,value,bits={},0,0
    for i=1,#source do
        local digit=lookup[source:sub(i,i)]
        if digit then
            value,bits=value*64+digit,bits+6
            if bits>=8 then
                bits=bits-8
                output[#output+1]=string.char(math.floor(value/2^bits))
                value=value%2^bits
            end
        end
    end
    return table.concat(output)
end

local function main()
    local Files = {CurrentPath = "", Entries = {}, Mode="Files", ResourceFilter="All"}
    local MAX_TEXT_SIZE = 256 * 1024
    local window, list, editor, editorTitle, address, search, status, saveButton, deleteButton
    local selected, openedPath, originalText, loading = nil, nil, "", false
    local rows = {}
    local prompt, promptName, promptMessage, promptDetail, promptAction
    local confirmCallback
    local atlasImage
    local tooltips=setmetatable({}, {__mode="k"})
    local toolbar,toolbarControls,copyButton,locateButton,exportButton
    local resourcePreview,imagePreview,modelPreview,editorViewport,resourceTitle
    local resourceRequest=0

    -- Executor filesystem APIs already resolve relative paths inside Workspace.
    -- Keep navigation relative; never prepend another literal Workspace folder.
    local function validName(name)
        return type(name) == "string" and name ~= "" and name ~= "." and name ~= ".."
            and not name:find('[\\/:*?"<>|%c]') and #name <= 255
    end
    local function validPath(path, allowRoot)
        if type(path) ~= "string" then return false end
        if path == "" then return allowRoot == true end
        if path:sub(1,1) == "/" or path:find("\\") then return false end
        for part in path:gmatch("[^/]+") do if not validName(part) then return false end end
        return not path:find("//",1,true) and path:sub(-1) ~= "/"
    end
    local function join(path, name) return path == "" and name or path .. "/" .. name end
    local function call(name, ...)
        if type(env[name]) ~= "function" then return nil, "File operation unavailable" end
        local ok, result = pcall(env[name], ...)
        if not ok then return nil, "File operation failed" end
        return true, result
    end
    local function exists(path)
        if type(env.isfile) ~= "function" or type(env.isfolder) ~= "function" then
            return nil, "File operation unavailable"
        end
        local fileOK, file = call("isfile", path)
        local dirOK, directory = call("isfolder", path)
        if not fileOK or not dirOK then return nil, "File operation failed" end
        return file == true or directory == true
    end

    function Files.ListDirectory(path)
        if not validPath(path, true) then return nil, "Invalid path" end
        if type(env.isfolder) ~= "function" then return nil, "File operation unavailable" end
        local ok, result = call("listfiles", path)
        -- Some executors require '.' instead of an empty string for Workspace.
        if (not ok or type(result) ~= "table") and path == "" then ok, result = call("listfiles", ".") end
        if not ok or type(result) ~= "table" then return nil, "Cannot read folder" end
        local entries, seen = {}, {}
        for _, item in ipairs(result) do
            if type(item) == "string" then
                local normalized = item:gsub("\\", "/"):gsub("/+$", "")
                local name = normalized:match("([^/]+)$")
                local traversal = false
                for part in normalized:gmatch("[^/]+") do if part == ".." then traversal = true end end
                -- APIs may return absolute paths. Only use the final name,
                -- then resolve it below the directory that was actually listed.
                if not traversal and validName(name) and not seen[name] then
                    local childPath = join(path, name)
                    local folderOK, isFolder = call("isfolder", childPath)
                    if folderOK then
                        seen[name] = true
                        entries[#entries+1] = {Name = name, Path = childPath, IsFolder = isFolder == true}
                    end
                end
            end
        end
        table.sort(entries, function(a,b)
            if a.IsFolder ~= b.IsFolder then return a.IsFolder end
            local x,y = a.Name:lower(), b.Name:lower()
            return x == y and a.Name < b.Name or x < y
        end)
        return entries
    end
    function Files.ReadText(path)
        if not validPath(path, false) then return nil, "Invalid path" end
        local ok, text = call("readfile", path)
        if not ok or type(text) ~= "string" then return nil, "Cannot read file" end
        if #text > MAX_TEXT_SIZE then return nil, "Text preview limit is 256 KB" end
        if text:find("%z") or not utf8.len(text) then return nil, "This file cannot be edited as text" end
        return text
    end
    function Files.WriteText(path, text)
        if not validPath(path, false) then return nil, "Invalid path" end
        if type(text) ~= "string" or #text > MAX_TEXT_SIZE then return nil, "Text preview limit is 256 KB" end
        return call("writefile", path, text)
    end
    function Files.CreateEntry(path, name, folder)
        if not validPath(path, true) or not validName(name) then return nil, "Invalid file or folder name" end
        local target = join(path,name)
        local found, err = exists(target)
        if found == nil then return nil, err end
        if found then return nil, "A file or folder with that name already exists" end
        local ok, result
        if folder then ok, result = call("makefolder", target)
        else ok, result = call("writefile", target, "") end
        return ok, ok and target or result
    end
    function Files.DeleteEntry(entry)
        if not entry or not validPath(entry.Path, false) then return nil, "Invalid path" end
        return call(entry.IsFolder and "delfolder" or "delfile", entry.Path)
    end

    local function ignore(gui) if Main.Localization then Main.Localization.Ignore(gui) end end
    local function new(class, parent, properties, untranslated)
        local gui = Instance.new(class)
        for key, value in pairs(properties) do gui[key] = value end
        if untranslated then ignore(gui) end
        gui.Parent = parent
        return gui
    end
    local function getAtlasImage()
        if atlasImage~=nil then return atlasImage or nil end
        atlasImage=false
        local getter=env.getcustomasset or getcustomasset or getsynasset
        if type(getter)~="function" or type(env.writefile)~="function" then return end
        if type(env.makefolder)=="function" then
            pcall(env.makefolder,"dex")
            pcall(env.makefolder,"dex/assets")
        end
        local path="dex/assets/filemanager_icons_v2.png"
        local ok=pcall(env.writefile,path,decodeBase64(ICON_ATLAS_BASE64))
        if ok then
            local loaded,image=pcall(getter,path)
            if loaded and type(image)=="string" and image~="" then atlasImage=image end
        end
        return atlasImage or nil
    end
    function Files.IconKind(entry)
        if entry.Kind then return entry.Kind end
        if entry.IsFolder then return "Folder" end
        local extension=entry.Name:lower():match("%.([^.]+)$")
        return (extension=="lua" or extension=="luau") and "Lua" or "File"
    end
    local function fallbackIcon(icon,kind)
        local gray=Color3.fromRGB(210,210,210)
        local function shape(x,y,w,h,color,round)
            local frame=new("Frame",icon,{Name="IconShape",BackgroundColor3=color or gray,BorderSizePixel=0,
                Position=UDim2.new(x,0,y,0),Size=UDim2.new(w,0,h,0)})
            if round then new("UICorner",frame,{CornerRadius=UDim.new(1,0)}) end
            return frame
        end
        local function line(x1,y1,x2,y2)
            local dx,dy=x2-x1,y2-y1
            local frame=shape((x1+x2)/2,(y1+y2)/2,math.sqrt(dx*dx+dy*dy),0.09)
            frame.AnchorPoint=Vector2.new(0.5,0.5)
            frame.Rotation=math.deg(math.atan2(dy,dx))
        end
        if kind=="Folder" or kind=="NewFolder" then
            shape(.08,.2,.35,.18); shape(.08,.35,.84,.5)
        elseif kind=="Lua" then
            shape(.1,.12,.76,.76,nil,true)
            shape(.58,.25,.2,.2,Color3.fromRGB(45,45,45),true)
            shape(.82,.02,.16,.16,nil,true)
            new("TextLabel",icon,{BackgroundTransparency=1,Position=UDim2.new(.17,0,.5,0),Size=UDim2.new(.55,0,.24,0),
                Text="Lua",Font=Enum.Font.SourceSansBold,TextScaled=true,TextColor3=Color3.fromRGB(45,45,45)})
        elseif kind=="Image" then
            line(.1,.1,.9,.1); line(.9,.1,.9,.9); line(.9,.9,.1,.9); line(.1,.9,.1,.1)
            shape(.65,.22,.15,.15,nil,true); line(.15,.78,.4,.45); line(.4,.45,.58,.67); line(.58,.67,.7,.52); line(.7,.52,.85,.78)
        elseif kind=="Model" then
            line(.5,.08,.9,.3); line(.9,.3,.9,.72); line(.9,.72,.5,.94); line(.5,.94,.1,.72)
            line(.1,.72,.1,.3); line(.1,.3,.5,.08); line(.1,.3,.5,.52); line(.5,.52,.9,.3); line(.5,.52,.5,.94)
        elseif kind=="Copy" then
            line(.32,.3,.9,.3); line(.9,.3,.9,.9); line(.9,.9,.32,.9); line(.32,.9,.32,.3)
            line(.1,.65,.1,.08); line(.1,.08,.65,.08); line(.65,.08,.65,.22)
        elseif kind=="Locate" then
            shape(.2,.2,.6,.6,nil,true); shape(.3,.3,.4,.4,Color3.fromRGB(35,35,35),true)
            line(.5,.02,.5,.25); line(.5,.75,.5,.98); line(.02,.5,.25,.5); line(.75,.5,.98,.5)
        elseif kind=="Up" then line(.5,.86,.5,.15); line(.2,.45,.5,.15); line(.5,.15,.8,.45)
        elseif kind=="Open" then line(.1,.5,.86,.5); line(.58,.2,.86,.5); line(.86,.5,.58,.8)
        elseif kind=="Cancel" then line(.2,.2,.8,.8); line(.8,.2,.2,.8)
        elseif kind=="Confirm" then line(.12,.5,.37,.76); line(.37,.76,.86,.23)
        elseif kind=="Search" then
            shape(.08,.08,.6,.6,nil,true)
            shape(.17,.17,.42,.42,Color3.fromRGB(35,35,35),true)
            line(.6,.6,.88,.88)
        elseif kind=="Refresh" then
            line(.15,.25,.8,.25); line(.8,.25,.8,.7); line(.8,.7,.25,.7)
            line(.25,.7,.25,.45); line(.8,.25,.64,.1); line(.8,.25,.94,.1)
        elseif kind=="Delete" then
            line(.15,.25,.85,.25); line(.28,.25,.32,.88); line(.72,.25,.68,.88)
            line(.32,.88,.68,.88); line(.38,.12,.62,.12)
        else
            line(.2,.1,.75,.1); line(.75,.1,.85,.25); line(.85,.25,.85,.9)
            line(.85,.9,.2,.9); line(.2,.9,.2,.1)
            if kind=="Save" then line(.35,.2,.65,.2); line(.35,.65,.7,.65)
            else line(.35,.4,.65,.4); line(.35,.6,.65,.6) end
        end
        if kind=="NewFolder" or kind=="NewFile" or kind=="Create" then
            line(.65,.65,.95,.65); line(.8,.5,.8,.8)
        end
    end
    local function drawIcon(parent,kind,position,size)
        local image=getAtlasImage()
        local icon=new("ImageLabel",parent,{Name="FileManagerIcon",BackgroundTransparency=1,
            Position=position,Size=size,Image=image or "",ImageColor3=Color3.fromRGB(255,255,255)})
        if image then
            icon.ImageRectOffset=Vector2.new((ICONS[kind] or ICONS.File)*32,0)
            icon.ImageRectSize=Vector2.new(32,32)
        else fallbackIcon(icon,kind) end
        return icon
    end
    local function setStatus(text) status.Text = text end
    local function dirty()
        return (openedPath ~= nil or (Files.Mode=="Game" and selected and selected.Property)) and editor.Text ~= originalText
    end
    local function updateActions()
        local gameMode=Files.Mode=="Game"
        saveButton:SetDisabled(not dirty() or (not gameMode and type(env.writefile)~="function"))
        saveButton:SetText(gameMode and "Apply Asset ID" or "Save")
        deleteButton:SetDisabled(not selected or (not gameMode and type(env[selected.IsFolder and "delfolder" or "delfile"])~="function"))
        editorTitle.Text = gameMode and (selected and selected.Path or "")
            or (openedPath and ("Workspace/" .. openedPath .. (dirty() and " *" or "")) or "")
        if copyButton then
            copyButton:SetDisabled(not selected or type(env.setclipboard)~="function")
            locateButton:SetDisabled(not selected)
            exportButton:SetDisabled(not selected or selected.Kind~="Model" or type(env.saveinstance)~="function")
        end
        if toolbarControls then
            local x=0
            for _,item in ipairs(toolbarControls) do
                local visible=not item.Mode or item.Mode==Files.Mode
                item.Button.Gui.Visible=visible
                if visible then item.Button.Gui.Position=UDim2.new(0,x,0,0); x=x+38 end
                if item.Selected then
                    item.Button.Gui.BackgroundColor3=Color3.fromRGB(item.Selected() and 85 or 48,item.Selected() and 85 or 48,item.Selected() and 85 or 48)
                end
            end
            toolbar.CanvasSize=UDim2.new(0,x,0,0)
        end
    end
    local function button(parent, text, position, size, action)
        local control = Lib.Button.new()
        control.Gui.Parent = parent
        control.Text, control.Position, control.Size = "", position, size
        control.Gui.BackgroundTransparency = 0.25
        local kinds={Up="Up",Refresh="Refresh",["New File"]="NewFile",["New Folder"]="NewFolder",Delete="Delete",
            Save="Save",Open="Open",Cancel="Cancel",OK="Confirm",Create="Create"}
        kinds["Workspace Files"],kinds["Game Resources"]="Folder","Model"
        kinds["All Resources"],kinds["Images and Textures"],kinds["Models"]="File","Image","Model"
        kinds["Copy Resource ID"],kinds["Locate in Explorer"],kinds["Export Model"],kinds["Apply Asset ID"]="Copy","Locate","Save","Confirm"
        local icon=drawIcon(control.Gui,kinds[text] or "File",UDim2.new(.5,-8,.5,-8),UDim2.new(0,16,0,16))
        local label=new("TextLabel",control.Gui,{Name="ButtonText",BackgroundTransparency=1,
            Visible=false,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),Text=text,TextColor3=Settings.Theme.Text,
            TextSize=14,Font=Enum.Font.SourceSans,TextTruncate=Enum.TextTruncate.AtEnd})
        local root=control.Gui
        while root.Parent and not root:IsA("ScreenGui") do root=root.Parent end
        if not tooltips[root] then
            tooltips[root]={Label=new("TextLabel",root,{Name="ActionTooltip",Visible=false,BackgroundColor3=Color3.fromRGB(48,48,48),
                BackgroundTransparency=.15,BorderColor3=Color3.fromRGB(80,80,80),Size=UDim2.new(0,150,0,24),
                Text="",TextColor3=Settings.Theme.Text,Font=Enum.Font.SourceSans,TextSize=14,ZIndex=30})}
        end
        local tooltip=tooltips[root]
        local function hideTooltip()
            if tooltip.Owner==control.Gui then tooltip.Label.Visible=false; tooltip.Owner=nil end
        end
        control.Gui.MouseEnter:Connect(function()
            local pos=control.Gui.AbsolutePosition
            tooltip.Owner=control.Gui
            tooltip.Label.Text=text
            tooltip.Label.Position=UDim2.new(0,pos.X,0,math.max(0,pos.Y-26))
            tooltip.Label.Visible=true
        end)
        control.Gui.MouseLeave:Connect(hideTooltip)
        control.Gui.Destroying:Connect(hideTooltip)
        control.OnClick:Connect(function() hideTooltip(); action() end)
        local result={Gui=control.Gui,Caption=label,Icon=icon}
        function result:SetDisabled(disabled)
            control:SetDisabled(disabled)
            label.TextTransparency=disabled and .5 or 0
            icon.ImageTransparency=disabled and .5 or 0
            for _,part in ipairs(icon:GetDescendants()) do
                if part.Name=="IconShape" then part.BackgroundTransparency=disabled and .5 or 0 end
                if part:IsA("TextLabel") then part.TextTransparency=disabled and .5 or 0 end
            end
        end
        function result:SetText(value)
            if text==value then return end
            text=value
            label.Text=value
            if tooltip.Owner==control.Gui then tooltip.Label.Text=value end
            if atlasImage then icon.ImageRectOffset=Vector2.new((ICONS[kinds[value]] or ICONS.File)*32,0)
            else
                for _,part in ipairs(icon:GetChildren()) do part:Destroy() end
                fallbackIcon(icon,kinds[value] or "File")
            end
        end
        return result
    end
    local function textBox(parent, properties)
        properties.BackgroundColor3 = Color3.fromRGB(35,35,35)
        properties.BackgroundTransparency = 0.3
        properties.BorderColor3 = Color3.fromRGB(70,70,70)
        properties.TextColor3 = Settings.Theme.Text
        properties.Font = Enum.Font.SourceSans
        properties.TextSize = 14
        properties.ClearTextOnFocus = false
        return new("TextBox", parent, properties)
    end
    local function showPrompt(title, message, detail, naming, callback)
        if not prompt then
            prompt = Lib.Window.new()
            prompt.Alignable = false
            prompt:SetResizable(false)
            prompt:Resize(360,155)
            prompt.GuiElems.Content.BackgroundColor3 = Color3.fromRGB(45,45,45)
            prompt.GuiElems.Content.BackgroundTransparency = 0.3
            promptMessage = new("TextLabel", prompt.GuiElems.Content, {
                BackgroundTransparency=1, Position=UDim2.new(0,10,0,8), Size=UDim2.new(1,-20,0,35),
                Font=Enum.Font.SourceSans, TextSize=14, TextColor3=Settings.Theme.Text, Text="", TextWrapped=true,
            })
            promptDetail = new("TextLabel", prompt.GuiElems.Content, {
                BackgroundTransparency=1, Position=UDim2.new(0,10,0,44), Size=UDim2.new(1,-20,0,24),
                Font=Enum.Font.SourceSans, TextSize=14, TextColor3=Settings.Theme.Text, Text="", TextTruncate=Enum.TextTruncate.AtEnd,
            })
            ignore(promptDetail)
            promptName = textBox(prompt.GuiElems.Content, {Position=UDim2.new(0,10,0,44), Size=UDim2.new(1,-20,0,24), Text="", PlaceholderText="File or folder name"})
            button(prompt.GuiElems.Content,"Cancel",UDim2.new(1,-82,1,-35),UDim2.new(0,32,0,25),function()
                confirmCallback = nil
                prompt:Hide()
            end)
            promptAction = button(prompt.GuiElems.Content,"OK",UDim2.new(1,-42,1,-35),UDim2.new(0,32,0,25),function()
                local callback = confirmCallback
                if callback then
                    local ok, err = callback(promptName.Text)
                    if ok == false then promptMessage.Text = err return end
                end
            end)
        end
        confirmCallback = function(name)
            if naming and not validName(name) then return false, "Invalid file or folder name" end
            prompt:Hide()
            confirmCallback = nil
            callback(name)
            return true
        end
        prompt:SetTitle(title)
        promptMessage.Text, promptDetail.Text, promptName.Text = message, detail or "", ""
        promptName.Visible, promptDetail.Visible = naming, not naming
        promptAction:SetText(naming and "Create" or "OK")
        prompt:Show()
        if naming then promptName:CaptureFocus() end
    end
    local function guardChanges(action)
        if dirty() then
            showPrompt("Unsaved Changes", "Discard unsaved changes?", openedPath or (selected and selected.Path), false, action)
        else action() end
    end
    local function clearEditor()
        loading = true
        openedPath, originalText, editor.Text = nil, "", ""
        editor.TextEditable = false
        loading = false
        if resourcePreview then
            imagePreview.Image=""
            imagePreview.Visible=false
            modelPreview.Visible=false
            modelPreview:ClearAllChildren()
        end
        updateActions()
    end
    local drawList,openResource
    local function openFile(entry)
        if openedPath == entry.Path then return end
        guardChanges(function()
            local text, err = Files.ReadText(entry.Path)
            if text == nil then setStatus(err) return end
            selected = entry
            loading = true
            openedPath, originalText, editor.Text = entry.Path, text, text
            editor.TextEditable = type(env.writefile) == "function"
            loading = false
            updateActions()
            drawList()
            setStatus("Opened: " .. entry.Name)
        end)
    end
    drawList = function()
        for _, row in ipairs(rows) do row:Destroy() end
        rows = {}
        local filter = search.Text:lower()
        local index = 0
        local gameMode=Files.Mode=="Game"
        local first=gameMode and math.max(1,math.floor((list.CanvasPosition and list.CanvasPosition.Y or 0)/27)) or 1
        local last=gameMode and first+math.ceil((list.AbsoluteSize and list.AbsoluteSize.Y or 324)/27)+4 or math.huge
        for _, entry in ipairs(Files.Entries) do
            local matchText=gameMode and (entry.Name.." "..entry.Path.." "..(entry.Content or "")) or entry.Name
            if matchText:lower():find(filter,1,true) then
                index = index+1
                if index>=first and index<=last then
                local row = new("TextButton", list, {
                    BackgroundColor3=Color3.fromRGB(selected==entry and 85 or 58,
                        selected==entry and 85 or 58, selected==entry and 85 or 58),
                    BackgroundTransparency=0.35, BorderSizePixel=0,
                    Position=UDim2.new(0,3,0,(index-1)*27), Size=UDim2.new(1,-12,0,25), Text="",
                    AutoButtonColor=true,
                })
                local label = new("TextLabel", row, {
                    BackgroundTransparency=1, Position=UDim2.new(0,30,0,0), Size=UDim2.new(1,entry.IsFolder and -68 or -35,1,0),
                    Text=entry.Name, Font=Enum.Font.SourceSans,
                    TextSize=14, TextColor3=Settings.Theme.Text, TextXAlignment=Enum.TextXAlignment.Left,
                    TextTruncate=Enum.TextTruncate.AtEnd,
                },true)
                ignore(label)
                drawIcon(row,Files.IconKind(entry),UDim2.new(0,6,0,4),UDim2.new(0,17,0,17))
                if entry.IsFolder then
                    local open=button(row,"Open",UDim2.new(1,-34,0,1),UDim2.new(0,32,1,-2),function()
                        guardChanges(function() Files.Navigate(entry.Path) end)
                    end)
                    open.Gui.Name="OpenFolder"
                end
                row.MouseButton1Click:Connect(function()
                    if entry.IsFolder then
                        selected = entry
                        updateActions()
                        drawList()
                        setStatus("Folder selected; click Open to enter")
                    elseif gameMode then openResource(entry)
                    else openFile(entry) end
                end)
                rows[#rows+1] = row
                end
            end
        end
        list.CanvasSize=UDim2.new(0,0,0,index*27)
    end
    function Files.Refresh()
        local entries,err
        if Files.Mode=="Game" then
            resourceRequest=resourceRequest+1
            local request=resourceRequest
            setStatus("Scanning game resources")
            entries,err=Apps.GameAssets.Scan(Files.ResourceFilter,function() return request~=resourceRequest or Files.Mode~="Game" end)
            if request~=resourceRequest or Files.Mode~="Game" then return false end
        else entries,err=Files.ListDirectory(Files.CurrentPath) end
        if not entries then setStatus(err) return false end
        Files.Entries = entries
        drawList()
        setStatus(Files.Mode=="Game" and ("Game resources: "..#entries) or (#entries == 0 and "Folder is empty" or "Files and folders: " .. #entries))
        return true
    end
    function Files.Navigate(path)
        local entries, err = Files.ListDirectory(path)
        if not entries then setStatus(err) return false end
        Files.CurrentPath, Files.Entries, selected = path, entries, nil
        address.Text = "Workspace" .. (path ~= "" and "/" .. path or "")
        search.Text = ""
        clearEditor()
        list.CanvasPosition = Vector2.new(0,0)
        drawList()
        setStatus(#entries == 0 and "Folder is empty" or "Files and folders: " .. #entries)
        return true
    end
    local function previewModel(entry)
        modelPreview:ClearAllChildren()
        local ok=pcall(function()
            local clone=entry.Object:Clone()
            if not clone then error("Cannot clone model") end
            -- Preview copies must not run scripts when parented into the UI.
            for _,object in ipairs(clone:GetDescendants()) do
                if object:IsA("LuaSourceContainer") then object:Destroy() end
            end
            local world=new("WorldModel",modelPreview,{})
            local model
            if clone:IsA("Model") then model=clone
            else model=new("Model",world,{}); clone.Parent=model end
            model.Parent=world
            local bounds,size=model:GetBoundingBox()
            local distance=math.max(size.Magnitude*1.2,2)
            local camera=new("Camera",modelPreview,{FieldOfView=50,
                CFrame=CFrame.lookAt(bounds.Position+Vector3.new(distance*.65,distance*.4,distance),bounds.Position)})
            modelPreview.CurrentCamera=camera
        end)
        if not ok then modelPreview:ClearAllChildren(); setStatus("Model preview unavailable") end
        return ok
    end
    openResource=function(entry)
        guardChanges(function()
            if not Apps.GameAssets.IsLive(entry) then setStatus("Resource is no longer available") return end
            selected=entry
            clearEditor()
            loading=true
            local ok,value=pcall(function() return entry.Property and entry.Object[entry.Property] or (entry.Class.."\n"..entry.Path) end)
            editor.Text=ok and tostring(value) or ""
            originalText=editor.Text
            editor.TextEditable=entry.Property~=nil
            editor.PlaceholderText="Asset ID or path"
            loading=false
            imagePreview.Visible=entry.Kind=="Image"
            modelPreview.Visible=entry.Kind=="Model"
            if entry.Kind=="Image" then imagePreview.Image=entry.Content
            else previewModel(entry) end
            updateActions(); drawList()
        end)
    end
    function Files.SetMode(mode)
        if mode~="Files" and mode~="Game" then return false end
        if mode==Files.Mode then return end
        guardChanges(function()
            resourceRequest=resourceRequest+1
            Files.Mode=mode
            selected=nil
            clearEditor()
            resourcePreview.Visible=mode=="Game"
            resourceTitle.Visible=mode=="Game"
            address.Visible=mode=="Files"
            editorViewport.Position=mode=="Game" and UDim2.new(.4,0,.65,6) or UDim2.new(.4,0,0,102)
            editorViewport.Size=mode=="Game" and UDim2.new(.6,-8,.35,-36) or UDim2.new(.6,-8,1,-132)
            search.PlaceholderText=mode=="Game" and "Search resources or asset IDs" or "Search files"
            search.Text=""
            list.CanvasPosition=Vector2.new(0,0)
            if mode=="Files" then
                editor.PlaceholderText="Select a text file to preview or edit"
                Files.Navigate(Files.CurrentPath)
            else Files.Refresh() end
            updateActions()
        end)
    end
    function Files.DrawIcon(icon)
        icon.Image=""
        drawIcon(icon,"Folder",UDim2.new(0,0,0,0),UDim2.new(1,0,1,0))
    end
    function Files.Init()
        window=Lib.Window.new()
        Files.Window=window
        window:SetTitle("File Manager")
        window:Resize(660,430)
        window.Alignable=false
        new("UISizeConstraint",window.GuiElems.Main,{MinSize=Vector2.new(420,260)})
        local content=window.GuiElems.Content
        content.BackgroundColor3=Color3.fromRGB(45,45,45)
        content.BackgroundTransparency=0.3
        window.GuiElems.TopBar.BackgroundColor3=Color3.fromRGB(50,50,50)
        window.GuiElems.TopBar.BackgroundTransparency=0.25
        address=new("TextLabel",content,{
            BackgroundTransparency=1,Position=UDim2.new(0,8,0,4),Size=UDim2.new(1,-16,0,22),
            Font=Enum.Font.SourceSans,TextSize=14,TextColor3=Settings.Theme.Text,Text="Workspace",
            TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
        })
        ignore(address)
        resourceTitle=new("TextLabel",content,{
            BackgroundTransparency=1,Position=UDim2.new(0,8,0,4),Size=UDim2.new(1,-16,0,22),Visible=false,
            Font=Enum.Font.SourceSans,TextSize=14,TextColor3=Settings.Theme.Text,Text="Game Resources",
            TextXAlignment=Enum.TextXAlignment.Left,
        })
        toolbar=new("ScrollingFrame",content,{
            Name="FileToolbar",Position=UDim2.new(0,8,0,30),Size=UDim2.new(1,-16,0,32),BackgroundTransparency=1,
            BorderSizePixel=0,ScrollBarThickness=4,ScrollingDirection=Enum.ScrollingDirection.X,CanvasSize=UDim2.new(0,532,0,0),
        })
        toolbarControls={}
        local function addToolbar(text,mode,action,active)
            local control=button(toolbar,text,UDim2.new(0,0,0,0),UDim2.new(0,32,0,28),action)
            toolbarControls[#toolbarControls+1]={Button=control,Mode=mode,Selected=active}
            return control
        end
        addToolbar("Workspace Files",nil,function() Files.SetMode("Files") end,function() return Files.Mode=="Files" end)
        addToolbar("Game Resources",nil,function() Files.SetMode("Game") end,function() return Files.Mode=="Game" end)
        addToolbar("Up","Files",function()
            if Files.CurrentPath=="" then return end
            guardChanges(function() Files.Navigate(Files.CurrentPath:match("^(.*)/[^/]+$") or "") end)
        end)
        addToolbar("Refresh",nil,Files.Refresh)
        local function createEntry(folder)
            showPrompt(folder and "New Folder" or "New File","File or folder name",nil,true,function(name)
                local ok,result=Files.CreateEntry(Files.CurrentPath,name,folder)
                if not ok then setStatus(result) return end
                Files.Refresh()
                setStatus("Created: "..name)
            end)
        end
        addToolbar("New File","Files",function() createEntry(false) end)
        addToolbar("New Folder","Files",function() createEntry(true) end)
        deleteButton=addToolbar("Delete",nil,function()
            local entry=selected
            if not entry then return end
            if Files.Mode=="Game" then
                showPrompt("Delete",entry.Property and "Clear this asset reference?" or "Delete this model from the current game?",entry.Path,false,function()
                    local ok,err=Apps.GameAssets.Remove(entry)
                    if not ok then setStatus(err) return end
                    selected=nil; clearEditor(); Files.Refresh()
                end)
                return
            end
            showPrompt("Delete",entry.IsFolder and "Delete this folder and all its contents?" or "Delete this file?",entry.Path,false,function()
                local ok,err=Files.DeleteEntry(entry)
                if not ok then setStatus(err) return end
                selected=nil
                if openedPath==entry.Path then clearEditor() end
                Files.Refresh()
                updateActions()
            end)
        end)
        copyButton=addToolbar("Copy Resource ID","Game",function()
            if not selected then return end
            local ok,message=Apps.GameAssets.Copy(selected)
            setStatus(message or (ok and "Copied resource ID or path" or "File operation failed"))
        end)
        locateButton=addToolbar("Locate in Explorer","Game",function()
            if not selected then return end
            local ok,err=Apps.GameAssets.Locate(selected)
            setStatus(ok and "Resource located in Explorer" or err)
        end)
        exportButton=addToolbar("Export Model","Game",function()
            local entry=selected
            if not entry or entry.Kind~="Model" then return end
            showPrompt("Export Model","File or folder name",nil,true,function(name)
                local target=join(Files.CurrentPath,name)
                for _,candidate in ipairs({target,target..".rbxm",target..".rbxmx"}) do
                    local found,err=exists(candidate)
                    if found==nil then setStatus(err) return end
                    if found then setStatus("A file or folder with that name already exists") return end
                end
                local ok,err=Apps.GameAssets.Export(entry,target)
                setStatus(ok and "Model exported" or err)
            end)
        end)
        for _,filter in ipairs({{"All","All Resources"},{"Images","Images and Textures"},{"Models","Models"}}) do
            addToolbar(filter[2],"Game",function()
                guardChanges(function()
                    Files.ResourceFilter=filter[1]; selected=nil; clearEditor()
                    list.CanvasPosition=Vector2.new(0,0); Files.Refresh(); updateActions()
                end)
            end,function() return Files.ResourceFilter==filter[1] end)
        end
        local searchBar=new("Frame",content,{Position=UDim2.new(0,8,0,72),Size=UDim2.new(0.4,-14,0,24),
            BackgroundColor3=Color3.fromRGB(35,35,35),BackgroundTransparency=.3,BorderSizePixel=0})
        drawIcon(searchBar,"Search",UDim2.new(0,5,0,4),UDim2.new(0,16,0,16))
        search=textBox(searchBar,{Position=UDim2.new(0,26,0,0),Size=UDim2.new(1,-30,1,0),Text="",PlaceholderText="Search files",BorderSizePixel=0})
        search.BackgroundTransparency=1
        list=new("ScrollingFrame",content,{
            Position=UDim2.new(0,8,0,102),Size=UDim2.new(0.4,-14,1,-132),BackgroundColor3=Color3.fromRGB(38,38,38),
            BackgroundTransparency=0.3,BorderSizePixel=0,ScrollBarThickness=6,CanvasSize=UDim2.new(0,0,0,0),
        })
        editorTitle=new("TextLabel",content,{
            BackgroundTransparency=1,Position=UDim2.new(0.4,0,0,72),Size=UDim2.new(0.6,-48,0,24),Text="",
            Font=Enum.Font.SourceSans,TextSize=14,TextColor3=Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
        })
        ignore(editorTitle)
        saveButton=button(content,"Save",UDim2.new(1,-40,0,72),UDim2.new(0,32,0,24),function()
            if Files.Mode=="Game" then
                if not selected or not selected.Property then return end
                local ok,value=Apps.GameAssets.SetContent(selected,editor.Text)
                if not ok then setStatus(value) return end
                loading=true; editor.Text=value; originalText=value; loading=false
                imagePreview.Image=value; updateActions(); drawList(); setStatus("Resource updated")
                return
            end
            if not openedPath then return end
            local ok,err=Files.WriteText(openedPath,editor.Text)
            if ok then originalText=editor.Text; updateActions(); setStatus("File saved") else setStatus(err) end
        end)
        local viewport=new("ScrollingFrame",content,{
            Position=UDim2.new(0.4,0,0,102),Size=UDim2.new(0.6,-8,1,-132),BackgroundColor3=Color3.fromRGB(32,32,32),
            BackgroundTransparency=0.3,BorderSizePixel=0,ScrollBarThickness=6,CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
        })
        editorViewport=viewport
        resourcePreview=new("Frame",content,{Visible=false,Position=UDim2.new(.4,0,0,102),Size=UDim2.new(.6,-8,.65,-102),
            BackgroundColor3=Color3.fromRGB(32,32,32),BackgroundTransparency=.3,BorderSizePixel=0})
        imagePreview=new("ImageLabel",resourcePreview,{Visible=false,Image="",Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit})
        modelPreview=new("ViewportFrame",resourcePreview,{Visible=false,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            Ambient=Color3.fromRGB(180,180,180),LightColor=Color3.fromRGB(255,255,255),LightDirection=Vector3.new(-1,-1,-1)})
        editor=textBox(viewport,{
            Name="FileContents",Position=UDim2.new(0,6,0,4),Size=UDim2.new(1,-18,0,20),AutomaticSize=Enum.AutomaticSize.Y,
            Text="",PlaceholderText="Select a text file to preview or edit",TextEditable=false,MultiLine=true,
            TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,BorderSizePixel=0,
        })
        editor.Font=Enum.Font.Code
        status=new("TextLabel",content,{
            BackgroundTransparency=1,Position=UDim2.new(0,8,1,-25),Size=UDim2.new(1,-16,0,20),Text="",
            Font=Enum.Font.SourceSans,TextSize=14,TextColor3=Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
        })
        search:GetPropertyChangedSignal("Text"):Connect(drawList)
        list:GetPropertyChangedSignal("CanvasPosition"):Connect(function() if Files.Mode=="Game" then drawList() end end)
        list:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() if Files.Mode=="Game" then drawList() end end)
        editor:GetPropertyChangedSignal("Text"):Connect(function() if not loading then updateActions() end end)
        window.OnActivate:Connect(Files.Refresh)
        window.OnDeactivate:Connect(function()
            local tooltip=tooltips[window.Gui]
            if tooltip then tooltip.Label.Visible=false; tooltip.Owner=nil end
        end)
        Files.Navigate("")
        updateActions()
    end
    return Files
end

local module={InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
