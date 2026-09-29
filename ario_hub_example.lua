-- ARIO HUB example — wires up: Premium theme (+ saved across sessions),
-- a key system, the new Badge element, gradient ProgressBar/Slider, and an
-- owner-only Admin tab that only renders for the "ariorblx11" account.
--
-- This is app-level code (your hub), not part of the WindUI library itself —
-- the library stays generic; this file is where you use it.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
-- (swap the URL above for your own hosted main.bundle.lua while testing)

--------------------------------------------------------------------------
-- Window + Key System
--------------------------------------------------------------------------

local Window = WindUI:CreateWindow({
	Title = "ARIO HUB",
	Icon = "gem",
	Author = "arioscripts",
	Folder = "ArioHub",
	Size = UDim2.fromOffset(600, 460),
	Theme = "Premium",
	SaveTheme = true, -- remembers "Premium" (or whatever the user picks) next session
	Resizable = true,

	KeySystem = {
		-- Simplest working setup: a fixed key list, saved locally after first
		-- entry so users aren't asked every time. Swap `Key` for a real
		-- backend below once you have a Platoboost/Luarmor project set up.
		Key = { "ario-test-key" },
		SaveKey = true,
		Title = "ARIO HUB — Key System",
		Note = "Get a key from the Discord.",

		-- Real backend example (uncomment + fill in your project id):
		-- API = {
		--     { Type = "Platoboost", ProjectId = "YOUR-PROJECT-ID" },
		-- },
	},
})

--------------------------------------------------------------------------
-- Main tab
--------------------------------------------------------------------------

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Badge({
	Title = "Welcome",
	Desc = "You're running the Premium theme.",
	Text = "PREMIUM",
	Color = "Accent", -- picks up the animated gold/violet gradient
})

MainTab:Button({
	Title = "Say hi",
	Callback = function()
		WindUI:Notify({ Title = "Hey!", Content = "Button pressed.", Duration = 3 })
	end,
})

MainTab:Toggle({
	Title = "Auto Farm",
	Default = false,
	Callback = function(state) end,
})

local Progress = MainTab:ProgressBar({
	Title = "Farm Progress",
	Value = 0,
	Min = 0,
	Max = 100,
})

MainTab:Slider({
	Title = "Farm Speed",
	Step = 1,
	Value = { Min = 1, Max = 10, Default = 5 },
	Callback = function(value) end,
})

-- demo: fill the progress bar up over time so you can see the gradient move
task.spawn(function()
	while true do
		for i = 0, 100, 2 do
			Progress:Set(i)
			task.wait(0.05)
		end
	end
end)

--------------------------------------------------------------------------
-- Settings tab (theme picker)
--------------------------------------------------------------------------

local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

SettingsTab:Dropdown({
	Title = "Theme",
	Values = { "Dark", "Light", "Premium", "Rainbow", "Amber" },
	Value = WindUI:GetCurrentTheme(),
	Callback = function(theme)
		WindUI:SetTheme(theme)
	end,
})

--------------------------------------------------------------------------
-- Admin tab — only ever built for the "ariorblx11" account. Everyone else's
-- client never even calls Window:Tab for it, so the tab simply doesn't exist
-- for them; this is a local, cosmetic/UI-only gate, not a security boundary.
--------------------------------------------------------------------------

if LocalPlayer.Name:lower() == "ariorblx11" then
	local AdminTab = Window:Tab({ Title = "Admin", Icon = "shield" })

	AdminTab:Badge({
		Title = "Owner Access",
		Desc = "Only you can see this tab.",
		Text = "OWNER",
		Color = Color3.fromHex("#f7d774"),
	})

	AdminTab:Paragraph({
		Title = "Session Info",
		Desc = ("User: %s (%d)\nHWID: %s"):format(
			LocalPlayer.Name,
			LocalPlayer.UserId,
			(gethwid and gethwid()) or "n/a"
		),
	})

	AdminTab:Button({
		Title = "Reload Hub",
		Desc = "Destroys and re-runs this script.",
		Callback = function()
			WindUI:Notify({ Title = "Reloading...", Duration = 1 })
			task.wait(0.5)
			Window:Destroy()
			loadstring(game:HttpGet("PUT_YOUR_HUB_URL_HERE"))()
		end,
	})

	AdminTab:Toggle({
		Title = "Debug Mode",
		Desc = "Extra warn() logging from the hub's own code.",
		Default = false,
		Callback = function(state)
			_G.ArioHubDebug = state
		end,
	})
end
