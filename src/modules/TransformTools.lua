--[[
Dex# selection transform tools. Icons adapted as square-ended GUI linework from
https://lucide.dev/icons/move, /scaling and /rotate-cw (not screenshot assets).

ISC License: Copyright (c) 2026 Lucide Icons and Contributors.
Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.
THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT,
OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Move icon also derives from Feather, MIT License: Copyright (c) 2013-present Cole Bemis.
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions: The above copyright notice and this
permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
local Main, Lib, Apps, Settings, service, plr
local function initDeps(data)
    Main, Lib, Apps, Settings, service, plr = data.Main, data.Lib, data.Apps, data.Settings, data.service, data.plr
end

-- Pure geometry is shared by mouse/touch controls; distances are from drag start.
local Geometry = {}
function Geometry.Rotate(v, degrees)
    local a = math.rad(degrees)
    return Vector2.new(v.X * math.cos(a) - v.Y * math.sin(a), v.X * math.sin(a) + v.Y * math.cos(a))
end
function Geometry.Offset(value, delta)
    return UDim2.new(value.X.Scale, value.X.Offset + delta.X, value.Y.Scale, value.Y.Offset + delta.Y)
end
function Geometry.MoveGui(start, delta)
    return Geometry.Offset(start.Position, Geometry.Rotate(delta, -start.ParentRotation) / start.PositionFactor)
end
function Geometry.ResizeGui(start, delta, sign)
    local localDelta = Geometry.Rotate(delta, -start.AbsoluteRotation)
    local dw = sign.X == 0 and 0 or math.max(4 - start.AbsoluteSize.X, localDelta.X * sign.X)
    local dh = sign.Y == 0 and 0 or math.max(4 - start.AbsoluteSize.Y, localDelta.Y * sign.Y)
    local size = Geometry.Offset(start.Size, Vector2.new(dw, dh) / start.SizeFactor)
    -- Rotated centre moves by half the resized edge; AnchorPoint then shifts
    -- the stored position without moving the opposite edge in screen space.
    local shift = Geometry.Rotate(Vector2.new(sign.X * dw / 2, sign.Y * dh / 2), start.Rotation)
        + Vector2.new((start.AnchorPoint.X - .5) * dw, (start.AnchorPoint.Y - .5) * dh)
    return Geometry.Offset(start.Position, shift / start.PositionFactor), size
end
function Geometry.AngleDelta(a, b)
    return (a - b + math.pi) % (2 * math.pi) - math.pi
end
function Geometry.MovePart(start, normal, distance)
    return start.CFrame * CFrame.new(normal * distance)
end
function Geometry.ResizePart(start, normal, distance)
    local axis = Vector3.new(math.abs(normal.X), math.abs(normal.Y), math.abs(normal.Z))
    local dimension = start.Size:Dot(axis)
    local change = math.clamp(dimension + distance, .05, 2048) - dimension
    return start.CFrame * CFrame.new(normal * (change / 2)), start.Size + axis * change
end
function Geometry.RotatePart(start, axis, angle)
    return start.CFrame * CFrame.fromAxisAngle(axis, angle)
end

local function main()
    local Tools = {Geometry = Geometry}
    local Explorer, Properties = Apps.Explorer, Apps.Properties
    local mode, target, drag, destroyed
    local connections, axes, buttons, icons = {}, {}, {}, {}
    local overlay, toolbarGui, toolbar, status, box, sizeLabel, rotateHandle
    local openButton, originalPosition, partBox, visualHolder, visualEnabled
    local guides, resizeHandles = {}, {}
    local messageDeadline = 0
    local BLUE, YELLOW = Color3.fromRGB(0,170,255), Color3.fromRGB(255,204,0)
    local modes = {{"Move","Move"},{"Scale","Scale"},{"Rotate","Rotate"}}
    local buttonWidth, buttonGap = 76, 2
    local toolbarWidth = #modes * buttonWidth + (#modes - 1) * buttonGap
    local function connect(signal, callback)
        local c = signal:Connect(callback)
        connections[#connections + 1] = c
        return c
    end
    local function new(class, parent, props)
        local obj = Instance.new(class)
        for key, value in pairs(props or {}) do obj[key] = value end
        obj.Parent = parent
        return obj
    end
    local function frame(parent, props)
        props = props or {}
        props.BorderSizePixel = props.BorderSizePixel or 0
        return new("Frame", parent, props)
    end
    local function line(parent, a, b, color, thickness)
        local delta = b - a
        return frame(parent, {AnchorPoint=Vector2.new(.5,.5), Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2),
            Size=UDim2.fromOffset(delta.Magnitude, thickness or 2), Rotation=math.deg(math.atan2(delta.Y,delta.X)), BackgroundColor3=color})
    end
    local function drawIcon(parent, kind)
        local function segment(x1,y1,x2,y2)
            local f = line(parent, Vector2.new(x1,y1), Vector2.new(x2,y2), Color3.new(1,1,1), 1.5)
            icons[#icons + 1] = {Frame=f, Mode=kind}
        end
        if kind == "Move" then
            segment(3,10,17,10) segment(10,3,10,17)
            segment(3,10,6,7) segment(3,10,6,13) segment(17,10,14,7) segment(17,10,14,13)
            segment(10,3,7,6) segment(10,3,13,6) segment(10,17,7,14) segment(10,17,13,14)
        elseif kind == "Scale" then
            segment(3,9,3,17) segment(3,17,11,17) segment(11,17,11,9) segment(11,9,3,9)
            segment(10,10,17,3) segment(12,3,17,3) segment(17,3,17,8)
        else
            -- Polygonal arc, deliberately square-ended instead of rounded.
            local points = {{16,6},{12,3},{7,3},{3,7},{3,13},{7,17},{13,17},{16,14}}
            for i=1,#points-1 do segment(points[i][1],points[i][2],points[i+1][1],points[i+1][2]) end
            segment(16,2,16,7) segment(16,7,11,7)
        end
    end
    local function label(parent, color)
        return new("TextLabel",parent,{BackgroundColor3=color or YELLOW,BorderSizePixel=0,TextColor3=Color3.new(0,0,0),
            TextSize=14,Font=Enum.Font.SourceSans,Size=UDim2.fromOffset(70,22),Text="",Active=false})
    end
    local function message(text, persist)
        messageDeadline = persist and os.clock()+3 or 0
        if status then status.Text=text or "" status.Visible=text ~= nil and text ~= "" end
    end
    local function refreshProperties()
        if Properties and Properties.ShowExplorerProps then pcall(Properties.ShowExplorerProps) end
    end
    local function finish(cancel)
        local previous = drag
        drag = nil
        if previous then
            if cancel then
                pcall(function()
                    if previous.Kind == "Gui" then
                        previous.Object.Size=previous.Size previous.Object.Position=previous.Position previous.Object.Rotation=previous.Rotation
                    else
                        previous.Object.Size=previous.Size previous.Object.CFrame=previous.CFrame
                    end
                end)
            end
            refreshProperties()
        end
    end
    local function apply(callback)
        local ok, err = pcall(callback)
        if not ok then
            finish(true)
            message("Cannot edit this object", true)
            warn("Dex# transform: " .. tostring(err))
        end
    end
    local function isInternal(obj)
        local current = obj
        while current do
            if current == Explorer.SelectionVisualsHolder or current == overlay or current == toolbarGui then return true end
            if current:IsA("ScreenGui") and current.Name:sub(1,5) == "_DPP_" then return true end
            current=current.Parent
        end
        return false
    end
    local function visibleGui(obj)
        local current = obj
        while current do
            if current:IsA("GuiObject") and not current.Visible then return false end
            if current:IsA("LayerCollector") and not current.Enabled then return false end
            current=current.Parent
        end
        return obj.AbsoluteSize.X > 0 and obj.AbsoluteSize.Y > 0
    end
    local function editable(obj)
        return obj and obj.Parent and not isInternal(obj) and (obj:IsA("GuiObject") or obj:IsA("BasePart"))
    end
    local function constraints(obj)
        local layout = obj.Parent and obj.Parent:FindFirstChildWhichIsA("UIGridStyleLayout")
        if mode == "Move" and layout then return "Layout controls position" end
        if mode == "Scale" then
            if layout and layout:IsA("UIGridLayout") then return "Grid layout controls size" end
            if obj.AutomaticSize ~= Enum.AutomaticSize.None then return "AutomaticSize controls size" end
        end
    end
    local function scaleFactor(obj, includeSelf)
        local factor, current = 1, includeSelf and obj or obj.Parent
        while current do
            if current:IsA("GuiObject") then
                for _, child in ipairs(current:GetChildren()) do
                    if child:IsA("UIScale") then factor = factor * child.Scale end
                end
            end
            current=current.Parent
        end
        return math.max(.0001,factor)
    end
    local function startGui(input, sign)
        if drag or not mode or not target or not target:IsA("GuiObject") then return end
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
        local reason = constraints(target)
        if reason then message(reason) return end
        local center = target.AbsolutePosition + target.AbsoluteSize/2
        local point = Vector2.new(input.Position.X,input.Position.Y)
        drag = {Kind="Gui",Object=target,Input=input,Point=point,Sign=sign,Position=target.Position,Size=target.Size,
            Rotation=target.Rotation,AbsoluteRotation=target.AbsoluteRotation,ParentRotation=target.AbsoluteRotation-target.Rotation,
            AnchorPoint=target.AnchorPoint,AbsoluteSize=target.AbsoluteSize,PositionFactor=scaleFactor(target,false),SizeFactor=scaleFactor(target,true),
            Center=center,LastAngle=math.atan2(point.Y-center.Y,point.X-center.X),Angle=0}
        message(nil)
    end
    local function dragGui(input)
        local d = drag
        if not d or d.Kind ~= "Gui" then return end
        if d.Input.UserInputType == Enum.UserInputType.Touch then
            if input ~= d.Input then return end
        elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local point = Vector2.new(input.Position.X,input.Position.Y)
        apply(function()
            if mode == "Move" then
                d.Object.Position=Geometry.MoveGui(d,point-d.Point)
            elseif mode == "Scale" then
                local pos, size = Geometry.ResizeGui(d,point-d.Point,d.Sign)
                d.Object.Size=size d.Object.Position=pos
            elseif mode == "Rotate" then
                local angle = math.atan2(point.Y-d.Center.Y,point.X-d.Center.X)
                d.Angle=d.Angle+Geometry.AngleDelta(angle,d.LastAngle) d.LastAngle=angle
                d.Object.Rotation=d.Rotation+math.deg(d.Angle)
            end
        end)
    end
    local function updateButtons()
        for _, item in ipairs(modes) do
            local button=buttons[item[1]]
            if button then
                button.TextColor3=target and Color3.new(1,1,1) or Color3.fromRGB(115,115,115)
                button.BackgroundColor3=mode==item[1] and Color3.fromRGB(30,83,110) or Color3.fromRGB(45,45,45)
                button.Active=target ~= nil
                button.SelectedLine.Visible=mode==item[1]
            end
        end
        for _, item in ipairs(icons) do item.Frame.BackgroundColor3=target and Color3.fromRGB(225,225,225) or Color3.fromRGB(115,115,115) end
    end
    local function restoreVisuals()
        if visualHolder then pcall(function() visualHolder.Enabled=visualEnabled end) end
        visualHolder, visualEnabled=nil,nil
    end
    local function updateVisuals()
        -- Original AttachTo does not follow Rotation. Use the accurate rotated
        -- outline for one selected GUI, suppressing its duplicate presentation.
        local guiOutline=target and target:IsA("GuiObject") and (mode or (Settings and Settings.Explorer.GuiSelectionBox))
        local partOutline=target and target:IsA("BasePart") and mode
        local holder=Explorer.SelectionVisualsHolder
        if visualHolder~=holder or not (guiOutline or partOutline) then restoreVisuals() end
        if holder and (guiOutline or partOutline) then
            if not visualHolder then visualHolder=holder visualEnabled=holder.Enabled end
            holder.Enabled=false
        end
        if partBox then partBox.Adornee=partOutline and target or nil end
        return guiOutline
    end
    local function updateAxes()
        for _, item in ipairs(axes) do
            local show = target and target:IsA("BasePart") and mode == item.Mode
            item.Handle.Adornee=show and target or nil
            item.Handle.Visible=show and true or false
        end
    end
    Tools.IsOverlayRoot = function(object) return object == overlay end
    Tools.SetMode = function(value)
        if destroyed then return end
        finish(false)
        mode=value
        if mode then
            for _, name in ipairs({"Click part to select","Click gui to select"}) do
                local picker=Main.MenuApps[name]
                if picker then picker.Disable() end
            end
        end
        message(nil)
        updateButtons() updateAxes() updateVisuals()
    end
    local function selectionChanged()
        finish(false)
        local list=Explorer.Selection.List
        local obj=#list==1 and list[1].Obj or nil
        local ok, allowed=pcall(editable,obj)
        target=ok and allowed and obj or nil
        message(nil)
        updateButtons() updateAxes() updateVisuals()
    end
    local function handleButton(parent, pos, size)
        return new("TextButton",parent,{AnchorPoint=Vector2.new(.5,.5),Position=pos,Size=size or UDim2.fromOffset(22,22),
            Text="",AutoButtonColor=false,BackgroundTransparency=1,BorderSizePixel=0})
    end
    local function makeGuiControls()
        overlay=new("ScreenGui",nil,{ResetOnSpawn=false,DisplayOrder=Main.DisplayOrders.Core+1,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
        Lib.ShowGui(overlay)
        partBox=new("SelectionBox",overlay,{LineThickness=.03,Color3=BLUE})
        box=frame(overlay,{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,Visible=false})
        for _, spec in ipairs({{0,-1,0,0,1,2,0,1},{0,-1,1,0,1,2,0,1},{0,-1,0,0,0,1,1,0},{1,0,0,0,0,1,1,0}}) do
            frame(box,{BackgroundColor3=BLUE,Position=UDim2.new(spec[1],spec[2],spec[3],spec[4]),Size=UDim2.new(spec[5],spec[6],spec[7],spec[8])})
        end
        for _, sign in ipairs({{-1,-1},{0,-1},{1,-1},{-1,0},{1,0},{-1,1},{0,1},{1,1}}) do
            local vector=Vector2.new(sign[1],sign[2])
            local button=handleButton(box,UDim2.fromScale((sign[1]+1)/2,(sign[2]+1)/2))
            frame(button,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(9,9),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=1,BorderColor3=BLUE})
            connect(button.InputBegan,function(input) startGui(input,vector) end)
            resizeHandles[#resizeHandles+1]=button
        end
        rotateHandle=handleButton(box,UDim2.new(.5,0,0,-27))
        frame(rotateHandle,{Position=UDim2.fromOffset(10,11),Size=UDim2.fromOffset(2,27),BackgroundColor3=BLUE})
        frame(rotateHandle,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(11,11),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=1,BorderColor3=BLUE})
        connect(rotateHandle.InputBegan,function(input) startGui(input) end)
        sizeLabel=label(overlay)
        sizeLabel.AnchorPoint=Vector2.new(.5,0) sizeLabel.Size=UDim2.fromOffset(104,22)
        for i=1,2 do
            local holder=frame(overlay,{BackgroundTransparency=1,Visible=false})
            local guide=frame(holder,{BackgroundColor3=YELLOW})
            local first=frame(holder,{BackgroundColor3=YELLOW})
            local last=frame(holder,{BackgroundColor3=YELLOW})
            local tag=label(holder)
            tag.AnchorPoint=Vector2.new(.5,.5)
            guides[i]={Holder=holder,Line=guide,First=first,Last=last,Label=tag}
        end
    end
    local function startPart()
        if drag or not target or not target:IsA("BasePart") then return end
        drag={Kind="Part",Object=target,CFrame=target.CFrame,Size=target.Size}
        message(nil)
    end
    local function makePartControls()
        local playerGui=plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui")
        local specs={
            {Axis=Enum.Axis.X,Vector=Vector3.new(1,0,0),Faces=Faces.new(Enum.NormalId.Left,Enum.NormalId.Right),Color=Color3.fromRGB(230,50,50)},
            {Axis=Enum.Axis.Y,Vector=Vector3.new(0,1,0),Faces=Faces.new(Enum.NormalId.Top,Enum.NormalId.Bottom),Color=Color3.fromRGB(40,210,70)},
            {Axis=Enum.Axis.Z,Vector=Vector3.new(0,0,1),Faces=Faces.new(Enum.NormalId.Front,Enum.NormalId.Back),Color=Color3.fromRGB(55,100,245)}
        }
        for _, spec in ipairs(specs) do
            for _, kind in ipairs({"Move","Scale","Rotate"}) do
                local h=new(kind=="Rotate" and "ArcHandles" or "Handles",nil,{Name="_DPP_Transform"..kind..spec.Axis.Name,Color3=spec.Color,Visible=false})
                if kind=="Rotate" then h.Axes=Axes.new(spec.Axis)
                else h.Faces=spec.Faces h.Style=kind=="Move" and Enum.HandlesStyle.Movement or Enum.HandlesStyle.Resize end
                -- Native handle input only works under PlayerGui/CoreGui, not ScreenGui.
                h.Parent=playerGui
                axes[#axes+1]={Handle=h,Mode=kind}
                connect(h.MouseButton1Down,startPart)
                connect(h.MouseButton1Up,function() finish(false) end)
                connect(h.MouseDrag,function(axisOrFace,distance)
                    if not drag or drag.Kind~="Part" then return end
                    local d=drag
                    apply(function()
                        if kind=="Rotate" then
                            d.Object.CFrame=Geometry.RotatePart(d,spec.Vector,distance)
                        else
                            local normal=Vector3.FromNormalId(axisOrFace)
                            if kind=="Move" then d.Object.CFrame=Geometry.MovePart(d,normal,distance)
                            else local cf,size=Geometry.ResizePart(d,normal,distance) d.Object.Size=size d.Object.CFrame=cf end
                        end
                    end)
                end)
            end
        end
    end
    local function renderGuide(index, first, last, horizontal)
        local g=guides[index]
        local lowX,lowY=math.min(first.X,last.X),math.min(first.Y,last.Y)
        local length=horizontal and math.abs(last.X-first.X) or math.abs(last.Y-first.Y)
        g.Holder.Position=UDim2.fromOffset(lowX,lowY)
        g.Line.Size=horizontal and UDim2.fromOffset(length,2) or UDim2.fromOffset(2,length)
        g.First.Position=UDim2.fromOffset(horizontal and 0 or -4,horizontal and -4 or 0)
        g.Last.Position=UDim2.fromOffset(horizontal and length or -4,horizontal and -4 or length)
        g.First.Size=horizontal and UDim2.fromOffset(2,10) or UDim2.fromOffset(10,2)
        g.Last.Size=g.First.Size
        g.Label.Position=horizontal and UDim2.fromOffset(length/2,0) or UDim2.fromOffset(0,length/2)
        g.Label.Text=tostring(math.round(horizontal and last.X-first.X or last.Y-first.Y))
        g.Holder.Visible=true
    end
    local function render()
        if destroyed then return end
        if target and not target.Parent then selectionChanged() end
        if openButton and toolbar then
            toolbar.Position=UDim2.fromOffset(openButton.AbsolutePosition.X+openButton.AbsoluteSize.X+4,openButton.AbsolutePosition.Y)
        end
        local show=updateVisuals() and visibleGui(target)
        box.Visible=show and true or false
        sizeLabel.Visible=show and mode~=nil or false
        for _, g in ipairs(guides) do g.Holder.Visible=false end
        if not show then return end
        local pos,size=target.AbsolutePosition,target.AbsoluteSize
        box.Position=UDim2.fromOffset(pos.X+size.X/2,pos.Y+size.Y/2)
        box.Size=UDim2.fromOffset(size.X,size.Y) box.Rotation=target.AbsoluteRotation
        local reason=constraints(target)
        if not drag and os.clock()>=messageDeadline then message(reason) end
        for _, h in ipairs(resizeHandles) do h.Visible=mode=="Scale" and not reason end
        rotateHandle.Visible=mode=="Rotate"
        sizeLabel.Position=UDim2.fromOffset(pos.X+size.X/2,pos.Y+size.Y+30)
        sizeLabel.Text=string.format("%d x %d",math.round(size.X),math.round(size.Y))
        if mode=="Move" or mode=="Scale" then
            local parent=target.Parent
            local origin=parent and parent:IsA("GuiObject") and parent.AbsolutePosition or Vector2.new(0,0)
            renderGuide(1,Vector2.new(origin.X,pos.Y+size.Y/2),Vector2.new(pos.X,pos.Y+size.Y/2),true)
            renderGuide(2,Vector2.new(pos.X+size.X/2,origin.Y),Vector2.new(pos.X+size.X/2,pos.Y),false)
        end
    end
    Tools.Init = function(button)
        openButton=button originalPosition=button.Position
        -- Centre the combined menu + three-button strip, including on narrow screens.
        button.Position=UDim2.new(originalPosition.X.Scale,originalPosition.X.Offset-(toolbarWidth+4)/2,originalPosition.Y.Scale,originalPosition.Y.Offset)
        toolbarGui=new("ScreenGui",nil,{ResetOnSpawn=false,DisplayOrder=Main.DisplayOrders.Core+2,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
        Lib.ShowGui(toolbarGui)
        toolbar=frame(toolbarGui,{BackgroundTransparency=1,Size=UDim2.fromOffset(toolbarWidth,32)})
        for i,item in ipairs(modes) do
            local b=new("TextButton",toolbar,{Name=item[1],Position=UDim2.fromOffset((i-1)*(buttonWidth+buttonGap),0),Size=UDim2.fromOffset(buttonWidth,32),
                Text=item[2],TextSize=16,TextScaled=false,Font=Enum.Font.SourceSansBold,TextTransparency=.2,BackgroundTransparency=.2,
                TextXAlignment=Enum.TextXAlignment.Right,AutoButtonColor=false,BorderSizePixel=0})
            new("UICorner",b,{CornerRadius=UDim.new(0,6)})
            new("UIPadding",b,{PaddingRight=UDim.new(0,4)})
            local icon=frame(b,{Position=UDim2.fromOffset(3,6),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1})
            drawIcon(icon,item[1])
            frame(b,{Name="SelectedLine",Position=UDim2.new(0,6,1,-3),Size=UDim2.new(1,-12,0,2),BackgroundColor3=BLUE,Visible=false})
            buttons[item[1]]=b
            connect(b.MouseButton1Click,function() if target then Tools.SetMode(mode~=item[1] and item[1] or nil) end end)
        end
        status=label(toolbar,Color3.fromRGB(45,45,45))
        status.TextColor3=Color3.new(1,1,1) status.Position=UDim2.fromOffset(-59,35) status.Size=UDim2.fromOffset(toolbarWidth+59,22) status.Visible=false
        makeGuiControls() makePartControls()
        connect(Explorer.Selection.Changed,selectionChanged)
        connect(service.UserInputService.InputBegan,function(input)
            if input.KeyCode==Enum.KeyCode.Escape and drag then finish(true) return end
            if mode~="Move" or not target or not target:IsA("GuiObject") then return end
            if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
            local pos=input.Position
            -- Native hit testing honours stacking/clipping and blocks Dex panels.
            local hit=Main.GetGuiAtPosition(pos.X,pos.Y)
            if hit and (hit==target or hit:IsDescendantOf(target)) then startGui(input) end
        end)
        connect(service.UserInputService.InputChanged,dragGui)
        connect(service.UserInputService.InputEnded,function(input)
            if not drag then return end
            if (drag.Kind=="Part" and input.UserInputType==Enum.UserInputType.MouseButton1)
                or (drag.Kind=="Gui" and (input==drag.Input or (drag.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1))) then finish(false) end
        end)
        if service.UserInputService.WindowFocusReleased then
            connect(service.UserInputService.WindowFocusReleased,function() finish(false) end)
        end
        connect(service.RunService.RenderStepped,function()
            local ok=pcall(render)
            if not ok then finish(false) target=nil updateAxes() updateButtons() box.Visible=false sizeLabel.Visible=false end
        end)
        selectionChanged() render()
    end
    Tools.Destroy = function()
        if destroyed then return end
        finish(false) destroyed=true
        restoreVisuals()
        for _, c in ipairs(connections) do c:Disconnect() end
        for _, item in ipairs(axes) do item.Handle:Destroy() end
        if toolbarGui then toolbarGui:Destroy() end
        if overlay then overlay:Destroy() end
        if openButton and openButton.Parent then openButton.Position=originalPosition end
        target=nil
    end
    return Tools
end
local module = {InitDeps=initDeps,InitAfterMain=function() end,Main=main}
if gethsfuncs then _G.moduleData=module else return module end
