local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/water5202/ui-libs/refs/heads/main/primordial%20remake/primordialsigma.lua"))()

local ui=library:createwindow({Title="primordial",ToggleKey=Enum.KeyCode.RightShift})
local rage=ui:addtab("Rage","rage")
local legit=ui:addtab("Legit","legit")
local visuals=ui:addtab("Visuals","visuals")
local misc=ui:addtab("Misc","misc")
local skins=ui:addtab("Skins","skins")
local scripts=ui:addtab("Scripts","scripts")

local aim=legit:addpage("Aim Assist","Help your aim")
local trigger=legit:addpage("Triggerbot","Shoot at players")
local weapons={"Rifles","Pistols","SMGs","Shotguns","Snipers","LMGs"}
for index,weapon in weapons do
    local pane=aim:addsubtab(weapon)
    local config=pane:addgroupbox("Weapon Configuration","Left",120)
    config:adddropdown({Id="Config_"..weapon,Text="Current Config",Values={"General","Shared","Custom"},Default="General"})
    config:addtoggle({Id="Override_"..weapon,Text="Override General Config",Default=index==1})
    local general=pane:addgroupbox("General","Left",229)
    general:addtoggle({Id="Enabled_"..weapon,Text="Enable"})
    general:addkeypicker({Id="AimKey_"..weapon,Text="Aim Key",Default="None",Mode="Hold"})
    general:adddropdown({Id="Disable_"..weapon,Text="Disable If...",Values={"None Selected...","Flashed","In Air","Reloading","Menu Open"}})
    local visualize=general:addtoggle({Id="DrawFOV_"..weapon,Text="Visualize FOV"})
    visualize:addcolorpicker({Id="FOVColor_"..weapon,Text="FOV Color",Default=rgb(223,34,44)})
    visualize:addcolorpicker({Id="FOVOutline_"..weapon,Text="FOV Outline",Default=rgb(208,20,33)})
    if index==1 then visualize:addcolorpicker({Id="FOVExtra_"..weapon,Text="Accent",Default=theme.Accent}) end
    general:adddropdown({Id="Recoil_"..weapon,Text="Recoil Control",Values={"On Aim","Always","Off"},Default="On Aim"})
    local targeting=pane:addgroupbox("Targeting","Right",174)
    targeting:adddropdown({Id="Hitbox_"..weapon,Text="Hitbox",Values={"Head","Chest","Torso","Closest"},Default="Head"})
    targeting:addslider({Id="FOV_"..weapon,Text="FOV",Min=0,Max=25,Default=4,Decimals=2})
    targeting:addslider({Id="Visible_"..weapon,Text="Min. Visibility Time",Min=0,Max=1000,Default=0,Suffix="ms"})
    local human=pane:addgroupbox("Humanization","Right",190)
    human:addtoggle({Id="Random_"..weapon,Text="Randomization",Default=true})
    human:addslider({Id="Pitch_"..weapon,Text="Speed (Pitch)",Min=0,Max=100,Default=30,Suffix="%"})
    human:addslider({Id="Yaw_"..weapon,Text="Speed (Yaw)",Min=0,Max=100,Default=30,Suffix="%"})
    human:addslider({Id="LimitAim_"..weapon,Text="Limit Aim Time",Min=0,Max=3000,Default=0,
        Format=function(v) return v==0 and "Off" or tostring(v).."ms" end})
end

local triggersub=trigger:addsubtab("General")
local triggerl=triggersub:addgroupbox("Triggerbot","Left")
triggerl:addtoggle({Id="TriggerEnabled",Text="Enable"})
triggerl:addkeypicker({Id="TriggerKey",Text="Trigger Key",Default="F"})
triggerl:adddropdown({Id="TriggerHitbox",Text="Target Hitbox",Values={"Head","Chest","Any"},Default="Any"})
triggerl:addslider({Id="TriggerDelay",Text="Delay",Min=0,Max=500,Default=65,Suffix="ms"})
local triggerr=triggersub:addgroupbox("Additional","Right")
triggerr:addtoggle({Id="TriggerWall",Text="Visibility Check",Default=true})
triggerr:addtoggle({Id="TriggerTeam",Text="Team Check",Default=true})
triggerr:addslider({Id="TriggerChance",Text="Trigger Chance",Min=0,Max=100,Default=90,Suffix="%"})

local ragepage=rage:addpage("Aimbot","Combat assistance")
local ragesub=ragepage:addsubtab("General")
local ra=ragesub:addgroupbox("Aimbot","Left")
ra:addtoggle({Id="RageEnabled",Text="Enable"})
ra:adddropdown({Id="RageTarget",Text="Target Selection",Values={"Closest to Crosshair","Closest Player","Lowest Health"}})
ra:addmultidropdown({Id="RageMultipoints",Text="Multipoints",Values={"Head","Chest","Stomach","Arms"},Default={"Head"}})
local rb=ragesub:addgroupbox("Accuracy","Right")
rb:addslider({Id="RageHitchance",Text="Hit Chance",Min=0,Max=100,Default=65,Suffix="%"})
rb:addslider({Id="RageDamage",Text="Minimum Damage",Min=0,Max=100,Default=35})
rb:addtoggle({Id="RageAuto",Text="Auto Fire"})

local esp=visuals:addpage("ESP","Player visuals")
local es=esp:addsubtab("Players")
local esl=es:addgroupbox("ESP","Left")
esl:addtoggle({Id="ESPEnable",Text="Enable"})
esl:addtoggle({Id="ESPBox",Text="Bounding Box",Default=true}):addcolorpicker({Id="ESPBoxColor",Default=theme.Accent})
esl:addtoggle({Id="ESPName",Text="Player Name",Default=true})
esl:addtoggle({Id="ESPHealth",Text="Health Bar",Default=true}):addcolorpicker({Id="ESPHealthColor",Default=theme.Green})
esl:addtoggle({Id="ESPDistance",Text="Distance"})
local esr=es:addgroupbox("Other","Right")
esr:addslider({Id="ESPRadius",Text="Draw Distance",Min=0,Max=2500,Default=1000,Suffix=" studs"})
esr:adddropdown({Id="ESPStyle",Text="Box Style",Values={"Outline","Corners","Filled"},Default="Outline"})
esr:addtoggle({Id="ESPTeam",Text="Team Check",Default=true})

local world=visuals:addpage("World","World rendering")
local ws=world:addsubtab("Effects")
local wl=ws:addgroupbox("World","Left")
local saved={Brightness=lightingservice.Brightness,Ambient=lightingservice.Ambient,OutdoorAmbient=lightingservice.OutdoorAmbient,
    Shadows=lightingservice.GlobalShadows,FogStart=lightingservice.FogStart,FogEnd=lightingservice.FogEnd,
    CameraFov=(workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView) or 70}
local worldstate={Fullbright=false,Tint=saved.Ambient,TintSet=false,NoShadows=false,Weather="Default"}
local worldmodified=false
local function applyworld()
    worldmodified=true
    lightingservice.Brightness=worldstate.Fullbright and 3 or saved.Brightness
    lightingservice.Ambient=worldstate.TintSet and worldstate.Tint or
        (worldstate.Fullbright and Color3.fromRGB(190,190,190) or saved.Ambient)
    lightingservice.OutdoorAmbient=worldstate.Fullbright and Color3.fromRGB(190,190,190) or saved.OutdoorAmbient
    lightingservice.GlobalShadows=worldstate.NoShadows and false or saved.Shadows
    if worldstate.Weather=="Foggy" then
        lightingservice.FogStart=0;lightingservice.FogEnd=140
    elseif worldstate.Weather=="Clear" then
        lightingservice.FogStart=0;lightingservice.FogEnd=100000
    else
        lightingservice.FogStart=saved.FogStart;lightingservice.FogEnd=saved.FogEnd
    end
end
wl:addtoggle({Id="WorldLight",Text="Fullbright",Callback=function(value)
    worldstate.Fullbright=value;applyworld()
end})
wl:addcolorpicker({Id="WorldTint",Text="Ambient Color",Default=saved.Ambient,
    Callback=function(color)
        worldstate.Tint=color;worldstate.TintSet=true;applyworld()
    end})
local cameramodified=false
wl:addslider({Id="WorldFov",Text="Camera FOV",Min=40,Max=120,Default=saved.CameraFov,
    Callback=function(value)
        cameramodified=true
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=value end
    end})
local wr=ws:addgroupbox("Effects","Right")
wr:adddropdown({Id="WorldWeather",Text="Atmosphere",Values={"Default","Clear","Foggy"},Default="Default",
    Callback=function(value) worldstate.Weather=value;applyworld() end})
wr:addtoggle({Id="WorldShadows",Text="Remove Shadows",
    Callback=function(value) worldstate.NoShadows=value;applyworld() end})
table.insert(library.CleanupCallbacks,function()
    if worldmodified then
        lightingservice.Brightness=saved.Brightness
        lightingservice.Ambient=saved.Ambient
        lightingservice.OutdoorAmbient=saved.OutdoorAmbient
        lightingservice.GlobalShadows=saved.Shadows
        lightingservice.FogStart=saved.FogStart
        lightingservice.FogEnd=saved.FogEnd
    end
    if cameramodified and workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView=saved.CameraFov
    end
end)

local settings=misc:addpage("Settings","Interface settings")
local inter=settings:addsubtab("Interface")
local gui=inter:addgroupbox("Interface","Left")
gui:addkeypicker({Id="MenuKey",Text="Toggle Menu Key",Default="RightShift",
    Changed=function(key) ui.ToggleKey=key end})
gui:addcolorpicker({Id="UIAccent",Text="Accent Color",Default=theme.Accent,
    Callback=function(color) library:setaccent(color) end})
gui:addtoggle({Id="Animations",Text="Smooth Animations",Default=true,
    Callback=function(val) library:setanimations(val) end})
gui:addslider({Id="InterfaceScale",Text="Interface Scale",Min=70,Max=130,Default=100,Suffix="%",
    Callback=function(val) library:setuiscale(val/100) end})
gui:addbutton({Text="Center Window",Callback=function()
    ui.Dragged=false
    ui.Root.Position=UDim2.fromScale(.5,.5)
    library:notify("Window centered")
end})
gui:addbutton({Text="Hide Menu",Callback=function() ui:setvisible(false) end})

local configgroup=inter:addgroupbox("PrimordialUI Configs","Right")
local configname=configgroup:addinput({Id="ConfigName",Text="New / Active Config",Default="Default",NoSave=true})
local configs=configgroup:adddropdown({Id="ConfigList",Text="Saved Configurations",NoSave=true,
    Values={"Default"},Default="Default",Callback=function(name) configname:setvalue(name,true) end})
local function refreshconfigs(keep)
    local names=library:listconfigs()
    if #names==0 then names={"Default"} end
    configs:setvalues(names)
    if keep then
        for unused,name in names do
            if name==keep then configs:setvalue(name,true);break end
        end
    end
end
configgroup:addbutton({Text="Save Config",Callback=function()
    local name=validconfigname(configname:getvalue())
    local ok,err=library:saveconfig(name)
    library:notify(ok and ("Saved: "..name) or ("Save failed: "..tostring(err)),3,ok and "success" or "error")
    if ok then refreshconfigs(name) end
end})
configgroup:addbutton({Text="Load Config",Callback=function()
    local name=validconfigname(configname:getvalue())
    local ok,err=library:loadconfig(name)
    library:notify(ok and ("Loaded: "..name.." ("..tostring(err).." settings)") or ("Load failed: "..tostring(err)),3,ok and "success" or "error")
end})
configgroup:addbutton({Text="Delete Config",Callback=function()
    local name=validconfigname(configname:getvalue())
    local ok,err=library:deleteconfig(name)
    library:notify(ok and ("Deleted: "..name) or ("Delete failed: "..tostring(err)),3,ok and "success" or "error")
    refreshconfigs()
end})
configgroup:addbutton({Text="Refresh Config List",Callback=function() refreshconfigs(configs:getvalue());library:notify("Config list refreshed") end})
configgroup:addbutton({Text="Set as Autoload",Callback=function()
    local name=validconfigname(configname:getvalue())
    local ok,err=library:setautoload(name)
    library:notify(ok and ("Autoload set: "..name) or ("Autoload failed: "..tostring(err)),3,ok and "success" or "error")
end})
configgroup:addbutton({Text="Clear Autoload",Callback=function()
    local ok=library:setautoload(nil)
    library:notify(ok and "Autoload cleared" or "Clear autoload failed",3,ok and "success" or "error")
end})
refreshconfigs(library:getautoload())

local skinpage=skins:addpage("Inventory","Appearance")
local sp=skinpage:addsubtab("Weapons")
local sl=sp:addgroupbox("Skin Preview","Left")
sl:addtoggle({Id="SkinsEnabled",Text="Preview Enabled"})
sl:adddropdown({Id="SkinsGun",Text="Weapon",Values={"AK-47","M4A1","AWP","Glock","Desert Eagle"}})
sl:addinput({Id="SkinName",Text="Skin Name",Default="Default"})
sl:addbutton({Text="Show Selection",Callback=function()
    library:notify("Selected: "..library.Options.SkinsGun:getvalue().." / "..library.Options.SkinName:getvalue())
end})
local sr=sp:addgroupbox("Colors","Right")
sr:addcolorpicker({Id="SkinPrimary",Text="Primary",Default=theme.Accent})
sr:addcolorpicker({Id="SkinSecondary",Text="Secondary",Default=theme.Green})
local scriptpage=scripts:addpage("Library","Your scripts")
local ss=scriptpage:addsubtab("Scripts")
local scriptleft=ss:addgroupbox("UI Controls","Left")
scriptleft:addinput({Id="ScriptTitle",Text="Script Title",Default="My Script"})
scriptleft:adddropdown({Id="ScriptFolder",Text="Category",Values={"General","Combat","Utility"}})
scriptleft:addbutton({Text="Test Callback",Callback=function() library:notify("Callback executed successfully") end})
local scriptright=ss:addgroupbox("Attachments Test","Right")
local attachment=scriptright:addtoggle({Id="TestToggle",Text="Multiple Pickers",Default=true})
attachment:addcolorpicker({Id="TestColorA",Text="Color A",Default=rgb(200,100,150)})
attachment:addcolorpicker({Id="TestColorB",Text="Color B",Default=rgb(40,160,210)})
attachment:addcolorpicker({Id="TestColorC",Text="Color C",Default=rgb(125,220,170)})
attachment:addkeypicker({Id="TestKey",Default="G",Mode="Toggle"})
scriptright:addmultidropdown({Id="TestMulti",Text="Multiple Selection",Values={"First","Second","Third"},Default={"First"}})

legit:select()
aim:select()
aim.Tabs[1]:select()
ui:relayout()
local autoload=library:getautoload()
if autoload then
    task.defer(function()
        local ok=library:loadconfig(autoload)
        if ok then library:notify("Autoloaded: "..autoload,2) end
    end)
end
