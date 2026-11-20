--!nocheck
-- Example: rebuilds the reference layout. Load the library however you host it:

local Pink = ... or (getgenv and getgenv().Pink) or Pink

local Window = Pink:Window({
	Name = "Pink",
	Keybind = Enum.KeyCode.V,                         -- show / hide every window
	Footer = { Status = "[UP] just a baseplate." },   -- "welcome back, <name>" is filled in automatically
	-- Panels = false,                                -- leave out Configurations / Appearance / Playerlist
})

local function buildMain(section, withGroups)
	local first = section:Toggle({ Name = "Toggle" })
	if withGroups then
		-- Dependency groups only show while their toggle is on.
		local outerGroup = first:Group()
		local groupToggle = outerGroup:Toggle({ Name = "Groupbox Toggle" })
		local inner = groupToggle:Group()
		inner:Slider({ Name = "Groupbox Slider", Min = 0, Max = 50, Default = 25 })
		inner:Colorpicker({ Name = "Groupbox Colorpicker", Default = Color3.new(1, 1, 1) })
		inner:Button({ Name = "Groupbox Button", Callback = function() Pink:Notify("Groupbox Button pressed") end })
	end
	section:Toggle({ Name = "Enabled Toggle", Default = true })
	section:Toggle({ Name = "Toggle" })

	section:Slider({ Name = "Integer Slider", Min = 0, Max = 100, Default = 50, Suffix = "%" })
	section:Slider({ Name = "Float Slider", Min = 0, Max = 50, Increment = 1, Default = 0, Suffix = "m/s" })
	section:Slider({ Name = "Decimal Slider", Min = 0, Max = 2, Increment = 0.1, Default = 0.5, Suffix = "s" })
	section:Slider({ Name = "String Slider", Min = 0, Max = 10, Default = 0, Format = function(v) return v == 0 and "inf" or tostring(v) end })
	section:Slider({ Name = "Range Slider", Min = 0, Max = 1000, Range = true, Default = { 0, 1000 } })

	section:Label("This Is A Text Label That Can Also Be Used As A Paragraph. The Quick Brown Fox Jumps Over The Lazy Dog.\nYou Can Also Break Lines\nLike This\nOr Like This")

	section:Toggle({ Name = "Toggle" })

	section:Slider({ Name = "Slider", Min = 0, Max = 100, Default = 50 })
	section:Dropdown({ Name = "Dropdown (Single)", Values = { "Option1", "Option2", "Option3", "Option4", "Option5" }, Default = "Option1" })
	section:Dropdown({ Name = "Dropdown (Multi)", Values = { "Option1", "Option2", "Option3", "Option4", "Option5" }, Default = { "Option1" }, Multi = true })
	section:Dropdown({ Name = "Dropdown", Values = { "Option1", "Option2", "Option3" }, Default = "Option1" })
	section:Dropdown({ Name = "Dropdown (No Default)", Values = { "Option1", "Option2", "Option3" } })
	local large = {}
	for i = 1, 40 do large[i] = "Option " .. i end
	section:Dropdown({ Name = "Dropdown (Large Option Set)", Values = large, Default = "Option 1" })
	section:Keybind({ Name = "Keybind", Default = Enum.KeyCode.E, Callback = function(active) print("Keybind", active) end })
	section:Keybind({ Name = "Keybind", Mode = "Hold" })
	section:Button({ Name = "Test Notif", Callback = function() Pink:Notify("Hello World! " .. math.random(100000, 999999)) end })
	section:Buttons({ { Name = "Button" }, { Name = "Button" } })
	section:Buttons({ { Name = "Button" }, { Name = "Button" }, { Name = "Button" } })
	section:Colorpicker({ Name = "Colorpicker", Default = Color3.new(1, 1, 1) })
	return first
end

local Main = Window:Tab("Main")
buildMain(Main:Section("Section 1", "Left"), true)
buildMain(Main:Section("Section 1", "Right"), false)

local Misc = Window:Tab("Misc")
for _, side in { "Left", "Right" } do
	local section = Misc:Section("Section 2", side)
	section:Toggle({ Name = "Toggle" })
	section:Toggle({ Name = "Enabled Toggle", Default = true })
	local withColors = section:Toggle({ Name = "Enabled Toggle", Default = true })
	withColors:Colorpicker({ Default = Color3.new(1, 1, 1) })
	withColors:Colorpicker({ Default = Color3.new(1, 1, 1) })
	if side == "Left" then
		-- A dependency box driven by a dropdown: only shows while "Advanced" is picked.
		local mode = section:Dropdown({ Name = "Mode", Values = { "Simple", "Advanced" }, Default = "Simple" })
		local advanced = section:DependencyBox()
		advanced:Slider({ Name = "Advanced Slider", Min = 0, Max = 10, Default = 3 })
		advanced:Toggle({ Name = "Advanced Toggle" })
		advanced:SetupDependencies({ { mode, "Advanced" } })
		for _ = 1, 3 do section:Dropdown({ Name = "Dropdown", Values = { "Option 1", "Option 2", "Option 3" }, Default = "Option 1" }) end
	end
	section:List({ Values = { "List Element 1", "List Element 324", "List Element 3", "List Element 2434", "List Element 6" }, Default = "List Element 1" })
	section:List({ Values = { "Option 1", "Option 2", "Option 3", "Option 4", "Option 5" }, Default = { "Option 1" }, Multi = true })
end

return Window
