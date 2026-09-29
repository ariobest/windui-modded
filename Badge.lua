-- [Premium] New element: a labeled row with a pill/badge on the right,
-- built on top of the existing components/ui/Tag. Handy for flagging
-- "PREMIUM", "NEW", "BETA", etc. next to a feature inside a Tab.
--
-- Usage:
--   Tab:Badge({
--       Title = "VIP Auto Farm",
--       Desc = "Only visible to key holders on the Premium tier",
--       Text = "PREMIUM",
--       Color = "Accent", -- Color3, a ColorSequence table (WindUI:Gradient), or a theme key string
--   })

local Creator = require("../modules/Creator")

local Tag = require("../components/ui/Tag")

local Element = {}

function Element:New(Config)
	local Badge = {
		__type = "Badge",
		Title = Config.Title or "Badge",
		Desc = Config.Desc or nil,
		Text = Config.Text or "NEW",
		Icon = Config.Icon or nil,
		Color = Config.Color or "Accent",
		UIElements = {},
	}

	Badge.BadgeFrame = require("../components/window/Element")({
		Title = Badge.Title,
		Desc = Badge.Desc,
		Window = Config.Window,
		Parent = Config.Parent,
		TextOffset = 24,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Badge,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	local TagInstance = Tag:New({
		Title = Badge.Text,
		Icon = Badge.Icon,
		Color = Badge.Color,
		Window = Config.Window,
	}, Badge.BadgeFrame.UIElements.Main)

	TagInstance.TagFrame.AnchorPoint = Vector2.new(1, 0.5)
	TagInstance.TagFrame.Position = UDim2.new(1, 0, 0.5, 0)

	Badge.UIElements.Tag = TagInstance

	function Badge:SetText(text)
		TagInstance:SetTitle(text)
		Badge.Text = text
		return Badge
	end

	function Badge:SetColor(color)
		TagInstance:SetColor(color)
		Badge.Color = color
		return Badge
	end

	function Badge:SetIcon(icon)
		TagInstance:SetIcon(icon)
		Badge.Icon = icon
		return Badge
	end

	return Badge.__type, Badge
end

return Element
