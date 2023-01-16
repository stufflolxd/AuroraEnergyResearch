--[[

	// @class
	// FileName: Highlight.lua
	// Written by: tgarbrecht
	// Description: Highlight classes for doors. Better organization.

]]

local module = {}
module.__index = module

local TweenService = game:GetService("TweenService")

module.New = function(HighlightPart)
	local self = setmetatable({}, module)
	local attributes = HighlightPart:GetAttributes()
	local data = {
		Highlight = HighlightPart,
		StoredTweens = {
			["HighlightBGIn"] = TweenService:Create(HighlightPart, TweenInfo.new(attributes.HighlightTime, Enum.EasingStyle.Linear), {FillTransparency = attributes.FillTransparencyEnabled}),
			["HighlightBGOut"] = TweenService:Create(HighlightPart, TweenInfo.new(attributes.HighlightTime, Enum.EasingStyle.Linear), {FillTransparency = 1}),

			["OutlineIn"] = TweenService:Create(HighlightPart, TweenInfo.new(attributes.HighlightTime, Enum.EasingStyle.Linear), {OutlineTransparency = attributes.OutlineTransparencyEnabled}),
			["OutlineOut"] = TweenService:Create(HighlightPart, TweenInfo.new(attributes.HighlightTime, Enum.EasingStyle.Linear), {OutlineTransparency = 1}),
		},
		Enabled = false
	}
	self.Data = data
	return self
end

function module:Enable()
	local data = self.Data
	local tweens = data.StoredTweens
	data.Highlight.Enabled = true
	data.Enabled = true
	tweens.HighlightBGOut:Pause()
	tweens.OutlineOut:Pause()
	tweens.HighlightBGIn:Play()
	tweens.OutlineIn:Play()
end

function module:Disable()
	local data = self.Data
	local tweens = data.StoredTweens
	data.Enabled = false
	tweens.HighlightBGIn:Pause()
	tweens.OutlineIn:Pause()
	tweens.HighlightBGOut:Play()
	tweens.OutlineOut:Play()
	tweens.HighlightBGOut.Completed:Wait()
	tweens.OutlineOut.Completed:Wait()
	if data.Enabled == false then
		data.Highlight.Enabled = false
	end
end

return module