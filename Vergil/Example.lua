local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/14273l/Vergil-poopy/refs/heads/main/Library"))()

local Window = Library:Window({
    Name = 'myscript | user | lifetime',
    Rank = "user",
})

Window:Watermark({ Name = "myscript.club", SubName = "v1.0" })
Window:KeybindList({ Name = 'hotkeys' })

local Combat  = Window:Page({ Name = "combat" })
local Visuals = Window:Page({ Name = "visuals" })
local Misc    = Window:Page({ Name = "misc" })

local Aimbot   = Combat:Section({ Name = "aimbot",   Side = 1 })
local GunMods  = Combat:Section({ Name = "gun mods", Side = 2 })
local ESP      = Visuals:Section({ Name = "esp",     Side = 1 })
local World    = Visuals:Section({ Name = "world",   Side = 2 })
local Movement = Misc:Section({ Name = "movement",   Side = 1 })
local Exploits = Misc:Section({ Name = "exploits",   Side = 2 })

-- ── Aimbot ────────────────────────────────────────────────
Aimbot:Toggle({ Name = "enabled",     Flag = "aim_on",     Default = false })
Aimbot:Toggle({ Name = "silent aim",  Flag = "aim_silent", Default = false })

Aimbot:Dropdown({
    Name = "target part",
    Flag = "aim_part",
    Items = { "Head", "Torso", "Random" },
    Default = "Head",
})

Aimbot:Dropdown({
    Name = "hitboxes",
    Flag = "aim_hitboxes",
    Items = { "Head", "Torso", "Arms", "Legs" },
    Default = { "Head", "Torso" },
    Multi = true,
})

Aimbot:Slider({ Name = "fov",        Flag = "aim_fov",    Min = 0, Max = 360, Default = 90,  Decimals = 1, Suffix = "°" })
Aimbot:Slider({ Name = "smoothness", Flag = "aim_smooth", Min = 1, Max = 20,  Default = 4,   Decimals = 1 })
Aimbot:Slider({ Name = "prediction", Flag = "aim_pred",   Min = 0, Max = 1,   Default = 0.15, Decimals = 0.01, Suffix = "s" })

local fov = Aimbot:Toggle({ Name = "draw fov", Flag = "aim_drawfov", Default = true })
fov:Colorpicker({ Flag = "aim_fovcolor", Default = Color3.fromRGB(126, 192, 255), Alpha = 0.35 })
fov:Keybind({ Flag = "aim_fovkey", Default = Enum.KeyCode.F, Mode = "Toggle" })

local adv = Aimbot:Toggle({ Name = "advanced", Flag = "aim_adv", Default = false })
local advS = adv:Settings()
advS:Toggle({ Name = "team check", Flag = "aim_team", Default = true })
advS:Toggle({ Name = "wall check", Flag = "aim_wall", Default = true })
advS:Slider({ Name = "max distance", Flag = "aim_dist", Min = 1, Max = 2000, Default = 500, Decimals = 0, Suffix = " studs" })

Aimbot:Button({
    Name = "reset",
    Callback = function() Library:Notification({ Name = "aimbot reset", Time = 2 }) end,
})

-- ── Gun Mods ──────────────────────────────────────────────
GunMods:Toggle({ Name = "no recoil",     Flag = "gun_norecoil", Default = false })
GunMods:Toggle({ Name = "no spread",     Flag = "gun_nospread", Default = false })
GunMods:Toggle({ Name = "infinite ammo", Flag = "gun_infammo",  Default = false })
GunMods:Slider({ Name = "fire rate",  Flag = "gun_firerate", Min = 1, Max = 100, Default = 50, Decimals = 0, Suffix = " rpm" })
GunMods:Slider({ Name = "damage x",   Flag = "gun_dmgmult",  Min = 1, Max = 10,  Default = 2,  Decimals = 0.1, Suffix = "x" })

GunMods:Dropdown({
    Name = "hit sound",
    Flag = "gun_hitsound",
    Items = { "None", "Beep", "Bell", "Click", "Pop" },
    Default = "Beep",
})

GunMods:Textbox({
    Name = "custom sound id",
    Flag = "gun_soundid",
    Placeholder = "1234567890",
    Numeric = true,
    Finished = true,
})

GunMods:Label({ Name = "tracer color" }):Colorpicker({
    Flag = "gun_tracer",
    Default = Color3.fromRGB(255, 80, 80),
    Alpha = 0.8,
})

-- ── ESP ───────────────────────────────────────────────────
ESP:Toggle({ Name = "enabled",    Flag = "esp_on",       Default = false })

ESP:Toggle({ Name = "box",        Flag = "esp_box",      Default = true }):Colorpicker({
    Flag = "esp_boxcolor",
    Default = Color3.fromRGB(255, 255, 255),
})

ESP:Toggle({ Name = "name",       Flag = "esp_name",     Default = true })
ESP:Toggle({ Name = "health bar", Flag = "esp_health",   Default = true })
ESP:Toggle({ Name = "distance",   Flag = "esp_distance", Default = false })

ESP:Dropdown({
    Name = "box style",
    Flag = "esp_boxstyle",
    Items = { "2D Flat", "2D Corner", "3D", "Skeleton" },
    Default = "2D Corner",
})

ESP:Slider({ Name = "max distance", Flag = "esp_maxdist", Min = 10, Max = 5000, Default = 1500, Decimals = 0, Suffix = " studs" })
ESP:Slider({ Name = "opacity",      Flag = "esp_opacity", Min = 0,  Max = 1,    Default = 1,    Decimals = 0.01 })

ESP:Label({ Name = "toggle esp" }):Keybind({
    Name = "esp",
    Flag = "esp_bind",
    Default = Enum.KeyCode.RightAlt,
    Mode = "Toggle",
})

-- ── World ─────────────────────────────────────────────────
World:Toggle({ Name = "fullbright",   Flag = "world_bright",  Default = false })
World:Toggle({ Name = "fog removal",  Flag = "world_nofog",   Default = false })
World:Toggle({ Name = "no particles", Flag = "world_noparts", Default = false })

World:Slider({ Name = "brightness", Flag = "world_level", Min = 0, Max = 5, Default = 2, Decimals = 0.1 })

World:Dropdown({
    Name = "time of day",
    Flag = "world_time",
    Items = { "Day", "Sunset", "Night", "Custom" },
    Default = "Day",
})

World:Button({
    Name = "reset lighting",
    Callback = function() Library:Notification({ Name = "lighting reset", Time = 2 }) end,
})

-- ── Movement ──────────────────────────────────────────────
Movement:Toggle({ Name = "speed hack", Flag = "move_speed", Default = false })
Movement:Slider({ Name = "walk speed", Flag = "move_ws",    Min = 16, Max = 200, Default = 16, Decimals = 1 })

Movement:Toggle({ Name = "jump hack",  Flag = "move_jump",  Default = false })
Movement:Slider({ Name = "jump power", Flag = "move_jp",    Min = 50, Max = 300, Default = 50, Decimals = 1 })

Movement:Toggle({ Name = "fly",        Flag = "move_fly",   Default = false })
Movement:Slider({ Name = "fly speed",  Flag = "move_flyspeed", Min = 1, Max = 300, Default = 50, Decimals = 1 })

Movement:Label({ Name = "fly keybind" }):Keybind({
    Name = "fly",
    Flag = "move_flybind",
    Default = Enum.KeyCode.G,
    Mode = "Hold",
})

-- ── Exploits ──────────────────────────────────────────────
Exploits:Button({
    Name = "rejoin server",
    Callback = function()
        Library:Notification({ Name = "rejoining...", Time = 2 })
        task.delay(1, function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end,
})

Exploits:Button({
    Name = "copy job id",
    Callback = function()
        if setclipboard then
            setclipboard(tostring(game.JobId))
            Library:Notification({ Name = "job id copied", Time = 2 })
        end
    end,
})

Exploits:Textbox({
    Name = "script url",
    Flag = "exploit_url",
    Placeholder = "https://...",
})

Exploits:Button({
    Name = "execute script",
    Callback = function()
        local url = Library.Flags["exploit_url"]
        if url and url ~= "" then
            pcall(function() loadstring(game:HttpGet(url))() end)
            Library:Notification({ Name = "script executed", Time = 2 })
        else
            Library:Notification({ Name = "enter a url first", Time = 3 })
        end
    end,
})

Exploits:Toggle({ Name = "anti afk", Flag = "exploit_antiafk", Default = true })

Exploits:Dropdown({
    Name = "action on join",
    Flag = "exploit_onjoin",
    Items = { "Nothing", "Notify", "Rejoin", "Hop" },
    Default = "Notify",
})

-- ── Build settings page + config window ───────────────────
Window:InitWindow()
