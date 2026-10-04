--[[
	Script Viewer App Module
	
	A script viewer that is basically a notepad
]]
-- Common Locals
local Main,Lib,Apps,Settings -- Main Containers
local Explorer, Properties, ScriptViewer, Notebook -- Major Apps
local API,RMD,env,service,plr,create,createSimple -- Main Locals

local function initDeps(data)
	Main = data.Main
	Lib = data.Lib
	Apps = data.Apps
	Settings = data.Settings

	API = data.API
	RMD = data.RMD
	env = data.env
	service = data.service
	plr = data.plr
	create = data.create
	createSimple = data.createSimple
end

local function initAfterMain()
	Explorer = Apps.Explorer
	Properties = Apps.Properties
	ScriptViewer = Apps.ScriptViewer
	Notebook = Apps.Notebook
end

local executorName = "Unknown"
local executorVersion = "???"
if identifyexecutor then
	local name,ver = identifyexecutor()
	executorName = name
	executorVersion = ver
elseif game:GetService("RunService"):IsStudio() then
	executorName = "Studio"
	executorVersion = version()
end

local function getPath(obj)
	if obj.Parent == nil then
		return "Nil parented"
	else
		return Explorer.GetInstancePath(obj)
	end
end

local function main()
	local ScriptViewer = {}
	local window, codeFrame
	
	local execute, clear, dumpbtn
	local deobfButton, deobfMenu
	local viewRequest = 0
	
	local PreviousScr = nil
	
	ScriptViewer.DumpFunctions = function(scr)
		-- thanks King.Kevin#6025 you'll obviously be credited (no discord tag since that can easily be impersonated)
		local getgc = getgc or get_gc_objects
		local getupvalues = (debug and debug.getupvalues) or getupvalues or getupvals
		local getconstants = (debug and debug.getconstants) or getconstants or getconsts
		local getinfo = (debug and (debug.getinfo or debug.info)) or getinfo
		local original = ("\n-- // Function Dumper made by King.Kevin\n-- // Script Path: %s\n\n--[["):format(getPath(scr))
		local dump = original
		local functions, function_count, data_base = {}, 0, {}
		function functions:add_to_dump(str, indentation, new_line)
			local new_line = new_line or true
			dump = dump .. ("%s%s%s"):format(string.rep("		", indentation), tostring(str), new_line and "\n" or "")
		end
		function functions:get_function_name(func)
			local n = getinfo(func).name
			return n ~= "" and n or "Unknown Name"
		end
		function functions:dump_table(input, indent, index)
			local indent = indent < 0 and 0 or indent
			functions:add_to_dump(("%s [%s] %s"):format(tostring(index), tostring(typeof(input)), tostring(input)), indent - 1)
			local count = 0
			for index, value in pairs(input) do
				count = count + 1
				if type(value) == "function" then
					functions:add_to_dump(("%d [function] = %s"):format(count, functions:get_function_name(value)), indent)
				elseif type(value) == "table" then
					if not data_base[value] then
						data_base[value] = true
						functions:add_to_dump(("%d [table]:"):format(count), indent)
						functions:dump_table(value, indent + 1, index)
					else
						functions:add_to_dump(("%d [table] (Recursive table detected)"):format(count), indent)
					end
				else
					functions:add_to_dump(("%d [%s] = %s"):format(count, tostring(typeof(value)), tostring(value)), indent)
				end
			end
		end
		function functions:dump_function(input, indent)
			functions:add_to_dump(("\nFunction Dump: %s"):format(functions:get_function_name(input)), indent)
			functions:add_to_dump(("\nFunction Upvalues: %s"):format(functions:get_function_name(input)), indent)
			for index, upvalue in pairs(getupvalues(input)) do
				if type(upvalue) == "function" then
					functions:add_to_dump(("%d [function] = %s"):format(index, functions:get_function_name(upvalue)), indent + 1)
				elseif type(upvalue) == "table" then
					if not data_base[upvalue] then
						data_base[upvalue] = true
						functions:add_to_dump(("%d [table]:"):format(index), indent + 1)
						functions:dump_table(upvalue, indent + 2, index)
					else
						functions:add_to_dump(("%d [table] (Recursive table detected)"):format(index), indent + 1)
					end
				else
					functions:add_to_dump(("%d [%s] = %s"):format(index, tostring(typeof(upvalue)), tostring(upvalue)), indent + 1)
				end
			end
			functions:add_to_dump(("\nFunction Constants: %s"):format(functions:get_function_name(input)), indent)
			for index, constant in pairs(getconstants(input)) do
				if type(constant) == "function" then
					functions:add_to_dump(("%d [function] = %s"):format(index, functions:get_function_name(constant)), indent + 1)
				elseif type(constant) == "table" then
					if not data_base[constant] then
						data_base[constant] = true
						functions:add_to_dump(("%d [table]:"):format(index), indent + 1)
						functions:dump_table(constant, indent + 2, index)
					else
						functions:add_to_dump(("%d [table] (Recursive table detected)"):format(index), indent + 1)
					end
				else
					functions:add_to_dump(("%d [%s] = %s"):format(index, tostring(typeof(constant)), tostring(constant)), indent + 1)
				end
			end
		end
		for _, _function in pairs(env.getgc()) do
			if typeof(_function) == "function" and getfenv(_function).script and getfenv(_function).script == scr then
				functions:dump_function(_function, 0)
				functions:add_to_dump("\n" .. ("="):rep(100), 0, false)
			end
		end
		local source = codeFrame:GetText()

		if dump ~= original then source = source .. dump .. "]]" end
		codeFrame:SetText(source)
		
		window:Show()
	end

	ScriptViewer.Init = function()
		window = Lib.Window.new()
		window:SetTitle("Notepad")
		window:Resize(500,400)
		ScriptViewer.Window = window

		codeFrame = Lib.CodeFrame.new()
		if Main.Localization then Main.Localization.Ignore(codeFrame.Frame) end
		codeFrame.Frame.Position = UDim2.new(0,0,0,20)
		codeFrame.Frame.Size = UDim2.new(1,0,1,-40)
		codeFrame.Frame.Parent = window.GuiElems.Content
		
		local toolbar = Instance.new("ScrollingFrame", window.GuiElems.Content)
		toolbar.Name = "ScriptToolbar"
		toolbar.BackgroundTransparency = 1
		toolbar.BorderSizePixel = 0
		toolbar.Size = UDim2.new(1,0,0,20)
		toolbar.ScrollBarThickness = 2
		toolbar.ScrollingDirection = Enum.ScrollingDirection.X
		toolbar.CanvasSize = UDim2.new(0,0,0,0)

		local copy = Instance.new("TextButton",toolbar)
		copy.BackgroundTransparency = 1
		copy.Text = "Copy to Clipboard"
		
		if env.setclipboard then
			copy.TextColor3 = Color3.new(1,1,1)
			copy.Interactable = true
		else
			copy.TextColor3 = Color3.new(0.5,0.5,0.5)
			copy.Interactable = false
		end

		copy.MouseButton1Click:Connect(function()
			local source = codeFrame:GetText()
			env.setclipboard(source)
		end)

		local save = Instance.new("TextButton",toolbar)
		save.BackgroundTransparency = 1
		save.Text = "Save to File"
		save.TextColor3 = Color3.new(1,1,1)
		
		if env.writefile then
			save.TextColor3 = Color3.new(1,1,1)
			save.Interactable = true
		else
			save.TextColor3 = Color3.new(0.5,0.5,0.5)
			--save.Interactable = false
		end

		save.MouseButton1Click:Connect(function()
			local source = codeFrame:GetText()
			local filename = "Place_"..game.PlaceId.."_Script_"..os.time()..".txt"

			Lib.SaveAsPrompt(filename,source)
			--env.writefile(filename,source)
		end)
		
		dumpbtn = Instance.new("TextButton",toolbar)
		dumpbtn.BackgroundTransparency = 1
		dumpbtn.Text = "Dump Functions"
		dumpbtn.TextColor3 = Color3.new(0.5,0.5,0.5)
		
		if env.getgc then
			dumpbtn.TextColor3 = Color3.new(1,1,1)
			dumpbtn.Interactable = true
		else
			dumpbtn.TextColor3 = Color3.new(0.5,0.5,0.5)
			dumpbtn.Interactable = false
		end

		dumpbtn.MouseButton1Click:Connect(function()
			if PreviousScr ~= nil then
				pcall(ScriptViewer.DumpFunctions, PreviousScr)
			end
		end)
		
		deobfButton = Lib.Button.new()
		deobfButton.Parent = toolbar
		deobfButton.Text = "Deobf: " .. env.getDecompileMode() .. " v"
		local redecompileButton = Lib.Button.new()
		redecompileButton.Parent = toolbar
		redecompileButton.Text = "Re-Deobf"

		-- Use Dex's menu ScreenGui, including its native layering/outside-click handling.
		deobfMenu = Lib.ContextMenu.new()
		deobfMenu.Iconless = true
		local menuTextWidth = service.TextService:GetTextSize("AdvancedDecompiler",14,Enum.Font.SourceSans,Vector2.new(1000,20)).X
		deobfMenu.Width = math.ceil(menuTextWidth) + 16
		deobfMenu.GuiElems.Entry.TextScaled = false
		deobfMenu.GuiElems.Entry.EntryName.TextScaled = false
		deobfMenu.GuiElems.Entry.EntryName.TextSize = 14
		for _, mode in ipairs(env.decompileModes) do
			local modeName = mode
			deobfMenu:Add({Name = modeName, OnClick = function()
				ScriptViewer.SetDecompileMode(modeName)
			end})
		end

		ScriptViewer.SetDecompileMode = function(mode)
			mode = env.getDecompileMode(mode)
			Settings.Decompiler.DecompilerFallback = mode
			Settings.Decompiler.PreferDecompilerFallback = mode ~= "Executor"
			deobfButton.Text = "Deobf: " .. mode .. " v"
			deobfMenu:Hide()
			if PreviousScr then task.spawn(ScriptViewer.ViewScript, PreviousScr, mode) end
		end
		deobfButton.OnClick:Connect(function()
			if deobfMenu.Gui.Parent then deobfMenu:Hide() return end
			local pos = deobfButton.Gui.AbsolutePosition
			deobfMenu:Show(pos.X, pos.Y + 20)
		end)
		redecompileButton.OnClick:Connect(function()
			if PreviousScr then task.spawn(ScriptViewer.ViewScript, PreviousScr, env.getDecompileMode()) end
		end)

		local toolbarButtons = {copy, save, dumpbtn, deobfButton.Gui, redecompileButton.Gui}
		for _, button in ipairs(toolbarButtons) do
			button.Font = Enum.Font.SourceSans
			button.TextScaled = false
			button.TextSize = 14
			button.TextTruncate = Enum.TextTruncate.AtEnd
		end
		local selectorWidth = math.ceil(service.TextService:GetTextSize("Deobf: AdvancedDecompiler v",14,Enum.Font.SourceSans,Vector2.new(1000,20)).X) + 12
		local function layoutToolbar()
			local fullWidth = 130 + 100 + 110 + selectorWidth + 72
			local compact = toolbar.AbsoluteSize.X < fullWidth
			copy.Text = compact and "Copy" or "Copy to Clipboard"
			save.Text = compact and "Save" or "Save to File"
			local widths = {compact and 42 or 130, compact and 42 or 100, compact and 96 or 110, selectorWidth, 72}
			-- Stretch the selector into unused space, keeping Re-Deobf at the right edge.
			local minimumWidth = widths[1] + widths[2] + widths[3] + widths[4] + widths[5]
			widths[4] = widths[4] + math.max(0, math.floor(toolbar.AbsoluteSize.X) - minimumWidth)
			local x = 0
			for i, button in ipairs(toolbarButtons) do
				button.Position = UDim2.new(0,x,0,0)
				button.Size = UDim2.new(0,widths[i],0,20)
				x = x + widths[i]
			end
			toolbar.CanvasSize = UDim2.new(0,x,0,20)
			-- Narrow windows keep every control accessible by horizontal scrolling.
			deobfMenu:Hide()
		end
		toolbar:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutToolbar)
		layoutToolbar()

		-- Buttons below the editor
		
		
		execute = Instance.new("TextButton",window.GuiElems.Content)
		execute.BackgroundTransparency = 1
		execute.Size = UDim2.new(0.5,0,0,20)
		execute.Position = UDim2.new(0,0,1,-20)
		execute.Text = "Execute"
		execute.TextColor3 = Color3.new(1,1,1)
		
		if env.loadstring then
			execute.TextColor3 = Color3.new(1,1,1)
			execute.Interactable = true
		else
			execute.TextColor3 = Color3.new(0.5,0.5,0.5)
			execute.Interactable = false
		end

		execute.MouseButton1Click:Connect(function()
			local source = codeFrame:GetText()
			env.loadstring(source)()
		end)

		clear = Instance.new("TextButton",window.GuiElems.Content)
		clear.BackgroundTransparency = 1
		clear.Size = UDim2.new(0.5,0,0,20)
		clear.Position = UDim2.new(0.5,0,1,-20)
		clear.Text = "Clear"
		clear.TextColor3 = Color3.new(1,1,1)

		clear.MouseButton1Click:Connect(function()
			viewRequest = viewRequest + 1
			codeFrame:SetText("")
		end)
	end
	
	ScriptViewer.ViewScript = function(scr, requestedMode)
		local mode = env.getDecompileMode(requestedMode)
		PreviousScr = scr
		viewRequest = viewRequest + 1
		local requestId = viewRequest
		if deobfButton then deobfButton.Text = "Deobf: " .. mode .. " v" end
		local oldtick = tick()
		local s,source = pcall(env.decompileWith,mode,scr)
		-- A slower earlier request must not replace the currently selected script/mode.
		if requestId ~= viewRequest then return end

		if not s or type(source) ~= "string" then
			dumpbtn.TextColor3 = Color3.new(0.5,0.5,0.5)
			local failure = tostring(source):gsub("\n", "\n-- ")
			source = "-- Unable to view source.\n-- " .. failure .. "\n"
			
			if Settings.ScriptViewer.ShowMoreInfo then
				source = source .. "-- Script Path: "..getPath(scr).."\n"
				if (scr.ClassName == "Script" and (scr.RunContext == Enum.RunContext.Legacy or scr.RunContext == Enum.RunContext.Server)) or not scr:IsA("LocalScript") then
					source = source .. "-- Reason: The script is not running on client. (attempt to decompile ServerScript or 'Script' with RunContext Server)\n"
				elseif not env.isdecompile() then
					source = source .. "-- Reason: Your executor does not support decompiler. (missing 'decompile' function and 'getscriptbytecode' function as fallback)\n"
				else
					source = source .. "-- Reason: Unknown Error.\n"
				end
				source = source .. "-- Executor: "..executorName.." ("..executorVersion..")"
			end
		else
			PreviousScr = scr
			dumpbtn.TextColor3 = env.getgc and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5)

			local decompiled = source

			source = "-- Script Path: "..getPath(scr).."\n"
			
			if Settings.ScriptViewer.ShowMoreInfo then
				source = source .. "-- Took "..tostring(math.floor( (tick() - oldtick) * 100) / 100).."s to decompile.\n"
				source = source .. "-- Deobf: "..mode.."\n"
				source = source .. "-- Executor: "..executorName.." ("..executorVersion..")\n\n"
			end
			
			source = source .. decompiled

			oldtick = nil
			decompiled = nil
		end

		codeFrame:SetText(source)
		window:Show()
	end

	return ScriptViewer
end

-- TODO: Remove when open source
if gethsfuncs then
	_G.moduleData = {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
else
	return {InitDeps = initDeps, InitAfterMain = initAfterMain, Main = main}
end