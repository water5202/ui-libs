--// yes native glow chams--// glow chams
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local bump = Vector3.new(0.03, 0.03, 0.03)
local hot = Color3.new(3, 1, 3)
local fill = Color3.fromRGB(190, 235, 255)

local function limb(p)
  local c = p.ClassName
  if c ~= "Part" and c ~= "MeshPart" then return false end
  if p.Name == "HumanoidRootPart" then return false end
  if p.Transparency >= 1 then return false end
  return true
end

local function paint(part)
  if part:FindFirstChild("Glow") then return end
  local size = part.Size + bump
  local g = Instance.new("BoxHandleAdornment")
  g.Name = "Glow"
  g.Adornee = part
  g.AlwaysOnTop = true
  g.ZIndex = 9
  g.Size = size
  g.Color3 = hot
  g.Transparency = -1
  g.Shading = 3
  g.Parent = part
  --[[
  local core = Instance.new("BoxHandleAdornment")
  core.Name = "Chams"
  core.Adornee = part
  core.AlwaysOnTop = true
  core.ZIndex = 10
  core.Size = part.Size + Vector3.new(0.02, 0.02, 0.02)
  core.Color3 = fill
  core.Transparency = 0.15
  core.Parent = part
  ]]
end

local function sweep()
  local list = Players:GetChildren()
  for i = 1, #list do
    local plr = list[i]
    if plr ~= lp and plr.ClassName == "Player" then
      local char = plr.Character
      if char then
        local kids = char:GetChildren()
        for j = 1, #kids do
          if limb(kids[j]) then paint(kids[j]) end
        end
      end
    end
  end
end

game:GetService("RunService").RenderStepped:Connect(function()
    sweep()
end)
