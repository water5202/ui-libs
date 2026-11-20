-- wally v3 bitches
-- credits to azixio for deobfuscating // @azixio.txt
-- made by susmic // @_susmic
-- 
local Library = {}

-- services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- global theme (matches the "Maxx" preset from original)
local Theme = {
    Main       = Color3.fromRGB(20, 20, 20),
    Secondary  = Color3.fromRGB(26, 26, 26),
    Tertiary   = Color3.fromRGB(38, 38, 38),
    Button     = Color3.fromRGB(255, 184, 0),
    Toggle     = Color3.fromRGB(255, 184, 0),
    Slider     = Color3.fromRGB(255, 184, 0),
    Text       = Color3.fromRGB(170, 170, 170),
    MainText   = Color3.fromRGB(255, 255, 255),
    ButtonText = Color3.fromRGB(0, 0, 0),
    Arrow      = Color3.fromRGB(96, 96, 96),
}

-- preset override
if getgenv and getgenv().Preset == "Maxx" then
    local c = Color3.fromRGB(255, 184, 0)
    Theme.Button, Theme.Toggle, Theme.Slider = c, c, c
end

-- shared rainbow state
local RainbowState = { i = 0, color = Color3.fromRGB(255, 0, 0) }
task.spawn(function()
    while true do
        for h = 0, 359 do
            RainbowState.i = h / 359
            RainbowState.color = Color3.fromHSV(h / 359, 1, 1)
            task.wait(0.03)
        end
    end
end)

-- helpers
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function makeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function roundSlice(obj)
    obj.ScaleType = Enum.ScaleType.Slice
    obj.SliceCenter = Rect.new(128, 128, 128, 128)
    obj.SliceScale = 0.05
end

-- key display map
local KeyDisplay = {
    RightControl = "RCtrl", LeftControl = "LCtrl",
    LeftShift = "LShift", RightShift = "RShift",
    MouseButton1 = "M1", MouseButton2 = "M2",
    LeftAlt = "LAlt", RightAlt = "RAlt",
    Space = "Space", Return = "Enter",
}

-- window counter (so multiple windows stack)
local WindowOffset = 0

-------------------------------------------------
-- CreateLib
-------------------------------------------------
function Library.CreateLib(title, theme)
    title = title or "UI"
    
    -- destroy old copies
    for _, v in pairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v:FindFirstChild("KavoRebornTag") then
            v:Destroy()
        end
    end
    
    local gui = create("ScreenGui", {
        Name = HttpService:GenerateGUID(false):gsub("[{}]", ""),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    create("IntValue", { Name = "KavoRebornTag", Parent = gui })
    
    -- toggle visibility with RightCtrl
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            gui.Enabled = not gui.Enabled
        end
    end)
    
    -- main window frame
    local Window = create("ImageLabel", {
        Name = "Window",
        Parent = gui,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15 + WindowOffset, 0, 15),
        Size = UDim2.new(0, 180, 0, 35),
        Image = "rbxassetid://4921672704",
        ImageColor3 = Theme.Main,
        ClipsDescendants = false,
    })
    roundSlice(Window)
    WindowOffset = WindowOffset + 200
    
    -- cap at bottom (hides rounding when tabs are open)
    create("Frame", {
        Name = "HideRounding",
        Parent = Window,
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -5),
        Size = UDim2.new(1, 0, 0, 5),
    })
    
    -- title
    local TitleLabel = create("TextLabel", {
        Name = "Title",
        Parent = Window,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.85, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "  " .. title,
        TextColor3 = Theme.MainText,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- arrow (close/open indicator)
    local Arrow = create("ImageLabel", {
        Name = "Arrow",
        Parent = Window,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0, 10),
        Size = UDim2.new(0, 12, 0, 12),
        Image = "rbxassetid://4921527706",
        ImageColor3 = Theme.Arrow,
    })
    
    -- tabs container
    local Tabs = create("Frame", {
        Name = "Sections",
        Parent = Window,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 0),
    })
    create("UIListLayout", {
        Parent = Tabs,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    
    makeDraggable(Window, Window)
    
    local WindowAPI = {}
    
    ---------------------------------------------
    -- NewTab
    ---------------------------------------------
    function WindowAPI:NewTab(tabName)
        tabName = tabName or "Tab"
        
        local TabFrame = create("Frame", {
            Name = "Folder",
            Parent = Tabs,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = UDim2.new(0, 180, 0, 35),
        })
        
        local TabHeader = create("ImageLabel", {
            Name = "FolderHeader",
            Parent = TabFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 180, 0, 35),
            Image = "rbxassetid://4641600283",
            ImageColor3 = Theme.Secondary,
        })
        roundSlice(TabHeader)
        
        local TabTitle = create("TextLabel", {
            Name = "Title",
            Parent = TabHeader,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(0.8, 0, 1, 0),
            Font = Enum.Font.SourceSansBold,
            Text = tabName,
            TextColor3 = Theme.MainText,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        local TabArrow = create("ImageLabel", {
            Name = "Arrow",
            Parent = TabHeader,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 0, 10),
            Size = UDim2.new(0, 12, 0, 12),
            Image = "rbxassetid://4921527706",
            ImageColor3 = Theme.Arrow,
            Rotation = 0,
        })
        
        local TabContent = create("Frame", {
            Name = "Content",
            Parent = TabHeader,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 0),
        })
        local ContentLayout = create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 3),
        })
        create("UIPadding", { Parent = TabContent, PaddingTop = UDim.new(0, 3) })
        
        local HeaderButton = create("TextButton", {
            Parent = TabHeader,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Text = "",
            ZIndex = 2,
        })
        
        -- collapse state
        local open = false
        HeaderButton.MouseButton1Click:Connect(function()
            open = not open
            if open then
                local target = ContentLayout.AbsoluteContentSize.Y + 42
                tween(TabFrame, 0.2, { Size = UDim2.new(0, 180, 0, target) })
                tween(TabHeader, 0.2, { Size = UDim2.new(0, 180, 0, target) })
                tween(TabArrow, 0.3, { Rotation = -90 })
            else
                tween(TabFrame, 0.2, { Size = UDim2.new(0, 180, 0, 35) })
                tween(TabHeader, 0.2, { Size = UDim2.new(0, 180, 0, 35) })
                tween(TabArrow, 0.3, { Rotation = 0 })
            end
        end)
        
        local TabAPI = {}
        
        -------------------------------------------
        -- Button
        -------------------------------------------
        function TabAPI:NewButton(name, _info, callback)
            callback = callback or function() end
            local Btn = create("ImageLabel", {
                Name = "Button",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 32),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
            })
            roundSlice(Btn)
            
            local Click = create("ImageButton", {
                Name = "Click",
                Parent = Btn,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0.9, 0, 0.7, 0),
                Image = "rbxassetid://4921672704",
                ImageColor3 = Theme.Button,
                AutoButtonColor = false,
            })
            roundSlice(Click)
            
            create("TextLabel", {
                Parent = Click,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSansBold,
                Text = name,
                TextColor3 = Theme.ButtonText,
                TextSize = 16,
            })
            
            Click.MouseButton1Click:Connect(function()
                tween(Click, 0.08, { Size = UDim2.new(0.85, 0, 0.6, 0) })
                task.wait(0.08)
                tween(Click, 0.1, { Size = UDim2.new(0.9, 0, 0.7, 0) })
                pcall(callback)
            end)
            return Btn
        end
        
        -------------------------------------------
        -- Toggle
        -------------------------------------------
        function TabAPI:NewToggle(name, _info, callback)
            callback = callback or function() end
            local Tgl = create("ImageLabel", {
                Name = "Toggle",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 32),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
            })
            roundSlice(Tgl)
            
            create("TextLabel", {
                Parent = Tgl,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 7, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.SourceSansSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local Tick = create("ImageButton", {
                Name = "Tick",
                Parent = Tgl,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -26, 0, 7),
                Size = UDim2.new(0, 18, 0, 18),
                Image = "rbxassetid://4608020054",
                ImageColor3 = Color3.fromRGB(94, 93, 94),
                AutoButtonColor = false,
            })
            roundSlice(Tick)
            
            local Fill = create("ImageLabel", {
                Name = "Fill",
                Parent = Tick,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 2, 0, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Image = "rbxassetid://4608020054",
                ImageColor3 = Theme.Tertiary,
            })
            roundSlice(Fill)
            
            local state = false
            Tick.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    tween(Tick, 0.1, { ImageColor3 = Theme.Toggle })
                    tween(Fill, 0.1, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
                else
                    tween(Tick, 0.1, { ImageColor3 = Color3.fromRGB(94, 93, 94) })
                    tween(Fill, 0.1, { Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2) })
                end
                pcall(callback, state)
            end)
            
            return {
                UpdateToggle = function(_, _, newState)
                    state = newState
                    if state then
                        Tick.ImageColor3 = Theme.Toggle
                        Fill.Size = UDim2.new(0, 0, 0, 0)
                        Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                    else
                        Tick.ImageColor3 = Color3.fromRGB(94, 93, 94)
                        Fill.Size = UDim2.new(1, -4, 1, -4)
                        Fill.Position = UDim2.new(0, 2, 0, 2)
                    end
                end,
            }
        end
        
        -------------------------------------------
        -- Slider
        -------------------------------------------
        function TabAPI:NewSlider(name, _info, max, min, callback)
            callback = callback or function() end
            max = max or 100
            min = min or 0
            
            local Sld = create("ImageLabel", {
                Name = "Slider",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 40),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
            })
            roundSlice(Sld)
            
            create("TextLabel", {
                Parent = Sld,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 7, 0.1, 0),
                Size = UDim2.new(0, 125, 0, 20),
                Font = Enum.Font.SourceSansSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local ValBox = create("TextBox", {
                Parent = Sld,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(65, 65, 65),
                BorderSizePixel = 0,
                Position = UDim2.new(0.96, 0, 0.3, 0),
                Size = UDim2.new(0, 32, 0, 16),
                Font = Enum.Font.SourceSansSemibold,
                Text = tostring(min),
                TextColor3 = Theme.Text,
                TextSize = 12,
            })
            create("UICorner", { Parent = ValBox, CornerRadius = UDim.new(0, 3) })
            
            local Track = create("ImageLabel", {
                Parent = Sld,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.8, 0),
                Size = UDim2.new(1, -14, 0, 4),
                Image = "rbxassetid://4608020054",
                ImageColor3 = Color3.fromRGB(46, 46, 46),
            })
            roundSlice(Track)
            
            local Indicator = create("Frame", {
                Parent = Track,
                BackgroundColor3 = Theme.Slider,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 1, 0),
            })
            create("UICorner", { Parent = Indicator, CornerRadius = UDim.new(1, 0) })
            
            local Dragger = create("ImageButton", {
                Parent = Indicator,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 12, 0, 12),
                Image = "rbxassetid://4608020054",
                ImageColor3 = Theme.Slider,
                AutoButtonColor = false,
            })
            create("UICorner", { Parent = Dragger, CornerRadius = UDim.new(1, 0) })
            
            local dragging = false
            local function updateFromMouse()
                local relX = math.clamp((Mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * relX)
                Indicator.Size = UDim2.new(relX, 0, 1, 0)
                ValBox.Text = tostring(value)
                pcall(callback, value)
            end
            
            Dragger.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            RunService.RenderStepped:Connect(function()
                if dragging then updateFromMouse() end
            end)
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateFromMouse()
                end
            end)
            
            ValBox.FocusLost:Connect(function()
                local n = tonumber(ValBox.Text)
                if n and n >= min and n <= max then
                    local rel = (n - min) / (max - min)
                    Indicator.Size = UDim2.new(rel, 0, 1, 0)
                    pcall(callback, n)
                else
                    ValBox.Text = "Min " .. min .. ", Max " .. max
                end
            end)
            
            return Sld
        end
        
        -------------------------------------------
        -- Keybind
        -------------------------------------------
        function TabAPI:NewKeybind(name, _info, defaultKey, callback)
            callback = callback or function() end
            local binding = false
            local currentKey = defaultKey or Enum.KeyCode.RightControl
            
            local Bnd = create("ImageLabel", {
                Name = "Bind",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 35),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
            })
            roundSlice(Bnd)
            
            create("TextLabel", {
                Parent = Bnd,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 7, 0, 2),
                Size = UDim2.new(0, 125, 0, 30),
                Font = Enum.Font.SourceSansSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local KeyBtn = create("TextButton", {
                Parent = Bnd,
                BackgroundColor3 = Color3.fromRGB(65, 65, 65),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -47, 0, 7),
                Size = UDim2.new(0, 40, 0, 21),
                Font = Enum.Font.SourceSansSemibold,
                Text = KeyDisplay[currentKey.Name] or currentKey.Name,
                TextColor3 = Theme.Text,
                TextSize = 12,
            })
            create("UICorner", { Parent = KeyBtn, CornerRadius = UDim.new(0, 3) })
            
            KeyBtn.MouseButton1Click:Connect(function()
                binding = true
                KeyBtn.Text = "..."
                local inp = UserInputService.InputBegan:Wait()
                currentKey = inp.KeyCode
                KeyBtn.Text = KeyDisplay[currentKey.Name] or currentKey.Name
                task.wait(0.1)
                binding = false
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe or binding then return end
                if input.KeyCode == currentKey then
                    pcall(callback)
                end
            end)
            
            return Bnd
        end
        
        -------------------------------------------
        -- Dropdown
        -------------------------------------------
        function TabAPI:NewDropdown(name, _info, options, callback)
            callback = callback or function() end
            options = options or {}
            
            local Drop = create("ImageLabel", {
                Name = "Dropdown",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 32),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                ClipsDescendants = true,
                LayoutOrder = 1,
            })
            roundSlice(Drop)
            
            local DropHeader = create("TextButton", {
                Parent = Drop,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                Font = Enum.Font.SourceSansSemibold,
                Text = "  " .. name,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local DropArrow = create("ImageLabel", {
                Parent = Drop,
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 0, 16),
                Size = UDim2.new(0, 12, 0, 12),
                Image = "rbxassetid://4921527706",
                ImageColor3 = Theme.Arrow,
                Rotation = 0,
            })
            
            local List = create("Frame", {
                Parent = Drop,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 32),
                Size = UDim2.new(1, 0, 0, 0),
            })
            local ListLayout = create("UIListLayout", { Parent = List, SortOrder = Enum.SortOrder.LayoutOrder })
            
            local function rebuild(opts)
                for _, c in ipairs(List:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for i, opt in ipairs(opts) do
                    local Item = create("TextButton", {
                        Parent = List,
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 22),
                        Font = Enum.Font.SourceSans,
                        Text = tostring(opt),
                        TextColor3 = Theme.Text,
                        TextSize = 14,
                        LayoutOrder = i,
                    })
                    Item.MouseButton1Click:Connect(function()
                        DropHeader.Text = "  " .. tostring(opt)
                        pcall(callback, opt)
                    end)
                end
            end
            rebuild(options)
            
            local open = false
            DropHeader.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    local h = #options * 22 + 34
                    tween(Drop, 0.2, { Size = UDim2.new(1, -6, 0, h) })
                    tween(DropArrow, 0.2, { Rotation = -90 })
                else
                    tween(Drop, 0.2, { Size = UDim2.new(1, -6, 0, 32) })
                    tween(DropArrow, 0.2, { Rotation = 0 })
                end
            end)
            
            return {
                Refresh = function(_, newOpts) rebuild(newOpts) end,
            }
        end
        
        -------------------------------------------
        -- ColorPicker (simplified — HSV hue bar + sat/val square)
        -------------------------------------------
        function TabAPI:NewColorPicker(name, _info, defaultColor, callback)
            callback = callback or function() end
            defaultColor = defaultColor or Color3.fromRGB(255, 0, 255)
            
            local Pick = create("ImageLabel", {
                Name = "ColorPicker",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 32),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
                ClipsDescendants = true,
            })
            roundSlice(Pick)
            
            create("TextLabel", {
                Parent = Pick,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 7, 0, 0),
                Size = UDim2.new(0, 125, 0, 30),
                Font = Enum.Font.SourceSansSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local Swatch = create("ImageButton", {
                Parent = Pick,
                BackgroundColor3 = defaultColor,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -47, 0, 5),
                Size = UDim2.new(0, 40, 0, 22),
                AutoButtonColor = false,
                Text = "",
            })
            create("UICorner", { Parent = Swatch, CornerRadius = UDim.new(0, 3) })
            
            -- picker body (hidden until open)
            local Body = create("Frame", {
                Parent = Pick,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 5, 0, 36),
                Size = UDim2.new(1, -10, 0, 120),
                Visible = false,
            })
            create("UICorner", { Parent = Body, CornerRadius = UDim.new(0, 4) })
            
            local SatVal = create("ImageLabel", {
                Parent = Body,
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(1, -30, 1, -10),
                BackgroundColor3 = defaultColor,
                BorderSizePixel = 0,
                Image = "rbxassetid://4921705601",
            })
            local Darkness = create("ImageLabel", {
                Parent = SatVal,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = "rbxassetid://4921703899",
                ImageColor3 = Color3.new(0, 0, 0),
            })
            
            local Hue = create("Frame", {
                Parent = Body,
                Position = UDim2.new(1, -20, 0, 5),
                Size = UDim2.new(0, 15, 1, -10),
                BorderSizePixel = 0,
            })
            local HueGrad = create("UIGradient", {
                Parent = Hue,
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
                }),
            })
            
            local h, s, v = 0, 1, 1
            local function refresh()
                local c = Color3.fromHSV(h, s, v)
                Swatch.BackgroundColor3 = c
                SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                pcall(callback, c)
            end
            
            local satDrag, hueDrag = false, false
            SatVal.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then satDrag = true end
            end)
            Hue.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = true end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then satDrag, hueDrag = false, false end
            end)
            RunService.RenderStepped:Connect(function()
                if satDrag then
                    s = math.clamp((Mouse.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((Mouse.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                    refresh()
                end
                if hueDrag then
                    h = math.clamp((Mouse.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
                    refresh()
                end
            end)
            
            local open = false
            Swatch.MouseButton1Click:Connect(function()
                open = not open
                Body.Visible = open
                if open then
                    tween(Pick, 0.2, { Size = UDim2.new(1, -6, 0, 160) })
                else
                    tween(Pick, 0.2, { Size = UDim2.new(1, -6, 0, 32) })
                end
            end)
            
            return Pick
        end
        
        -------------------------------------------
        -- TextBox
        -------------------------------------------
        function TabAPI:NewTextBox(name, _info, callback)
            callback = callback or function() end
            local Box = create("ImageLabel", {
                Name = "Box",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 33),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
            })
            roundSlice(Box)
            
            create("TextLabel", {
                Parent = Box,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 7, 0, 2),
                Size = UDim2.new(0, 100, 0, 30),
                Font = Enum.Font.SourceSansSemibold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local Input = create("TextBox", {
                Parent = Box,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -50, 0, 6),
                Size = UDim2.new(0, 45, 0, 21),
                Font = Enum.Font.SourceSansBold,
                PlaceholderText = "...",
                Text = "",
                TextColor3 = Color3.fromRGB(216, 216, 216),
                TextSize = 12,
            })
            create("UICorner", { Parent = Input, CornerRadius = UDim.new(0, 3) })
            
            Input.FocusLost:Connect(function()
                pcall(callback, Input.Text)
            end)
            
            return Box
        end
        
        -------------------------------------------
        -- Label
        -------------------------------------------
        function TabAPI:NewLabel(text)
            local Lbl = create("ImageLabel", {
                Name = "Label",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 32),
                Image = "rbxassetid://4641600283",
                ImageColor3 = Theme.Tertiary,
                LayoutOrder = 1,
            })
            roundSlice(Lbl)
            
            local LblText = create("TextLabel", {
                Parent = Lbl,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSansSemibold,
                Text = text,
                TextColor3 = Theme.MainText,
                TextSize = 16,
            })
            
            return {
                UpdateLabel = function(_, newText) LblText.Text = newText end,
            }
        end
        
        return TabAPI
    end
    
    function WindowAPI:DestroyGui()
        gui:Destroy()
    end
    
    return WindowAPI
end

return Library