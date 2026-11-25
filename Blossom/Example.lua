-- Demo layout matching the reference. Controls are labels only: wire your own Callback functions.
local Blossom = ...
if not Blossom then
	if script and script.Parent and script.Parent:FindFirstChild("Blossom") then
		Blossom = require(script.Parent.Blossom)
	else
		Blossom = loadstring(readfile("Blossom.luau"))()
	end
end

local Window = Blossom.new({ Title = "Blossom", Script = "blossom.lua", Build = "operation one" })

Window:Category("Combat")
local Rage = Window:Tab({ Name = "Rage", Icon = "target" })
local Legit = Window:Tab({ Name = "Legit", Icon = "bullet" })
Window:Category("Visuals")
local PlayersTab = Window:Tab({ Name = "Players", Icon = "smile" })
local Effects = Window:Tab({ Name = "Effects", Icon = "globe" })
Window:Category("Player")
local Movement = Window:Tab({ Name = "Movement", Icon = "smile" })
local Exploits = Window:Tab({ Name = "Exploits", Icon = "bomb" })
local Plugins = Window:Tab({ Name = "Plugins", Icon = "file" })
local Settings = Window:Tab({ Name = "Settings", Icon = "gear" })

local Ragebot = Rage:Section({ Name = "Ragebot", Icon = "robot", Side = 1 })
Ragebot:Toggle({ Name = "Enabled", Default = true, Keybind = Enum.KeyCode.C })
Ragebot:Divider()
Ragebot:Toggle({ Name = "Auto Shoot", Default = true })
Ragebot:Toggle({ Name = "Auto Scope", Default = true })
Ragebot:Toggle({ Name = "Auto Scope", Default = true })
Ragebot:Toggle({ Name = "Auto Scope", Default = true })
Ragebot:Toggle({ Name = "Auto Scope", Default = false })
Ragebot:Toggle({ Name = "Auto Reload", Default = false })
Ragebot:Toggle({ Name = "Force Headshot", Default = false })
Ragebot:Divider()
Ragebot:Toggle({ Name = "Autowall", Default = true })
Ragebot:Slider({ Name = "Min Damage", Min = 1, Max = 100, Default = 20, Suffix = "hp" })
Ragebot:Slider({ Name = "Hitchance", Min = 0, Max = 100, Default = 85, Suffix = "%" })
Ragebot:RangeSlider({ Name = "Damage Range", Min = 0, Max = 100, Default = { 20, 80 }, Suffix = "hp" })
Ragebot:Divider()
Ragebot:Dropdown({ Name = "Target Selection", Options = { "Closest to Crosshair", "Lowest Health", "Highest Threat", "Closest Distance" }, Default = "Closest to Crosshair" })
Ragebot:Slider({ Name = "Max Distance", Min = 0, Max = 2000, Default = 798, Suffix = "st" })

local Targeting = Rage:Section({ Name = "Targeting", Icon = "bullet", Side = 1 })
Targeting:Dropdown({ Name = "Hitboxes", Options = { "Head", "Torso", "Arms", "Legs" }, Default = { "Head", "Torso" }, Multi = true })

local Silent = Rage:Section({ Name = "Silent Aim", Icon = "bullet", Side = 2 })
Silent:Toggle({ Name = "Enabled", Default = false, Keybind = Enum.KeyCode.V })
Silent:Divider()
Silent:Toggle({ Name = "Use FOV", Default = true })
Silent:Toggle({ Name = "Draw FOV", Default = true, Color = Color3.fromRGB(216, 222, 218) })
Silent:Slider({ Name = "FOV Size", Min = 0, Max = 500, Default = 120, Suffix = "px" })
Silent:Divider()
Silent:Slider({ Name = "Hitchance", Min = 0, Max = 100, Default = 100, Suffix = "%" })
Silent:Dropdown({ Name = "Aim Point", Options = { "Head", "Torso", "Closest" }, Default = "Head" })
Silent:Toggle({ Name = "Prediction", Default = true })
Silent:Slider({ Name = "Prediction Amount", Min = 0, Max = 5, Default = 1.2, Decimals = 1, Suffix = "x" })

local AntiAim = Rage:Section({ Name = "Anti Aim", Icon = "wrench", Description = "Desync & angles", Side = 2 })
AntiAim:Toggle({ Name = "Enabled", Default = false, Keybind = Enum.KeyCode.Z })
AntiAim:Divider()
AntiAim:Dropdown({ Name = "Pitch", Options = { "None", "Down", "Up", "Zero", "Random" }, Default = "Zero" })
AntiAim:Dropdown({ Name = "Yaw", Options = { "Backward", "Spin", "Jitter" }, Default = "Backward" })
AntiAim:Slider({ Name = "Spin Speed", Min = 0, Max = 100, Default = 20 })
AntiAim:Slider({ Name = "Jitter Range", Min = 0, Max = 180, Default = 45 })
AntiAim:Divider()
AntiAim:Toggle({ Name = "Fake Duck", Default = false })
AntiAim:Toggle({ Name = "Freestanding", Default = true })

local Aim = Legit:Section({ Name = "Aim Assist", Icon = "target", Side = 1 })
Aim:Toggle({ Name = "Enabled", Default = true })
Aim:Divider()
Aim:Toggle({ Name = "Draw FOV", Default = true, Color = Color3.fromRGB(255, 255, 255) })
Aim:Slider({ Name = "FOV", Min = 0, Max = 500, Default = 200, Suffix = "px" })
Aim:Slider({ Name = "Smoothness", Min = 0, Max = 100, Default = 40, Suffix = "%" })
Aim:Dropdown({ Name = "Hitpart", Options = { "Head", "Torso" }, Default = "Head" })
Aim:Toggle({ Name = "Visible Only", Default = true })
Aim:Toggle({ Name = "Team Check", Default = true })

local Recoil = Legit:Section({ Name = "Recoil Control", Icon = "wrench", Side = 1 })
Recoil:Toggle({ Name = "Enabled", Default = false })
Recoil:Slider({ Name = "Vertical", Min = 0, Max = 100, Default = 70, Suffix = "%" })

local Trigger = Legit:Section({ Name = "Triggerbot", Icon = "bullet", Side = 2 })
Trigger:Toggle({ Name = "Enabled", Default = false, Keybind = Enum.KeyCode.T })
Trigger:Divider()
Trigger:Slider({ Name = "Reaction Delay", Min = 0, Max = 500, Default = 60, Suffix = "ms" })
Trigger:Toggle({ Name = "Magnet Trigger", Default = false })
Trigger:Slider({ Name = "Magnet FOV", Min = 0, Max = 100, Default = 25 })
Trigger:Toggle({ Name = "Head Only", Default = true })

local PlayerESP = PlayersTab:Section({ Name = "Players", Icon = "smile", Side = 1 })
PlayerESP:Toggle({ Name = "Enabled", Default = false, Color = Color3.fromRGB(95, 136, 202) })
PlayerESP:Toggle({ Name = "Names", Default = true })
PlayerESP:Toggle({ Name = "Boxes", Default = true, Color = Color3.fromRGB(255, 255, 255) })
PlayerESP:Toggle({ Name = "Health", Default = true })

local World = Effects:Section({ Name = "Local", Icon = "smile", Side = 1 })
World:Toggle({ Name = "Remove Flash", Default = false })
World:Toggle({ Name = "Third Person", Default = false })
World:Slider({ Name = "Third Person Distance", Min = 0, Max = 30, Default = 12 })
World:Slider({ Name = "Ratio", Min = 0, Max = 200, Default = 100 })

local Lighting = Effects:Section({ Name = "World", Icon = "globe", Side = 2 })
Lighting:Toggle({ Name = "Ambience", Default = false, Color = Color3.fromRGB(180, 200, 255) })
Lighting:Toggle({ Name = "Fog", Default = false })
Lighting:Slider({ Name = "Fog Start", Min = 0, Max = 1000, Default = 100 })
Lighting:Slider({ Name = "Fog End", Min = 0, Max = 1000, Default = 800 })
Lighting:Slider({ Name = "Clock Time", Min = 0, Max = 24, Default = 14 })

local Move = Movement:Section({ Name = "Movement", Icon = "smile", Side = 1 })
Move:Toggle({ Name = "Speed", Default = true })
Move:Slider({ Name = "Speed Amount", Min = 16, Max = 200, Default = 50 })
Move:Dropdown({ Name = "Speed Type", Options = { "WalkSpeed", "CFrame", "Velocity" }, Default = "WalkSpeed" })
Move:Divider()
Move:Toggle({ Name = "Fly", Default = true, Keybind = Enum.KeyCode.F })
Move:Slider({ Name = "Fly Speed", Min = 1, Max = 300, Default = 60 })
Move:Toggle({ Name = "NoClip", Default = false, Keybind = Enum.KeyCode.N })

local Hop = Movement:Section({ Name = "Bunny Hop", Icon = "smile", Side = 2 })
Hop:Toggle({ Name = "Enabled", Default = false })
Hop:Dropdown({ Name = "Mode", Options = { "Auto Strafe", "Legit" }, Default = "Auto Strafe" })
Hop:Slider({ Name = "Strafe Strength", Min = 0, Max = 100, Default = 40, Suffix = "%" })

local ExploitMain = Exploits:Section({ Name = "Main", Icon = "bomb", Side = 1 })
ExploitMain:Toggle({ Name = "Double Tap", Default = false })
ExploitMain:Toggle({ Name = "Hide Shots", Default = false })

Plugins:Section({ Name = "Plugins", Icon = "file", Side = 1 }):Label({ Name = "No plugins loaded" })

Window:BuildSettings(Settings)

return Window
