--[[

	// @class
	// FileName: InteractionUI.lua
	// Written by: tgarbrecht
	// Description: Interaction UI (not handler).

]]

local module = {}
module.__index = module

local TweenService = game:GetService("TweenService")

module.New = function(Gui)
	local self = setmetatable({}, module)
	self.Data = {
		Gui = Gui,
		StoredTweens = {
			["CircleTransparencyIn"] = TweenService:Create(Gui.Circulo, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {BackgroundTransparency = 0}),
			["LineSizeIn"] = TweenService:Create(Gui.Linea, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Size = UDim2.new(0.005, 0, 0.2, 0)}),
			["TitleTransparencyIn"] = TweenService:Create(Gui.Linea.TitleText, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextTransparency = 0}),
			["DescriptionTransparencyIn"] = TweenService:Create(Gui.Linea.DescriptionText, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextTransparency = 0}),
			
			["CircleTransparencyOut"] = TweenService:Create(Gui.Circulo, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {BackgroundTransparency = 1}),
			["LineSizeOut"] = TweenService:Create(Gui.Linea, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Size = UDim2.new(0.005, 0, 0, 0)}),
			["TitleTransparencyOut"] = TweenService:Create(Gui.Linea.TitleText, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextTransparency = 1}),
			["DescriptionTransparencyOut"] = TweenService:Create(Gui.Linea.DescriptionText, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextTransparency = 1}),
		},
		Enabled = false
	}
	return self
end

function module:Enable()
	local data = self.Data
	local tweens = data.StoredTweens
	data.Gui.Enabled = true
	tweens.CircleTransparencyOut:Pause()
	tweens.LineSizeOut:Pause()
	tweens.TitleTransparencyOut:Pause()
	tweens.DescriptionTransparencyOut:Pause()
	
	tweens.CircleTransparencyIn:Play()
	tweens.CircleTransparencyIn.Completed:Wait()
	tweens.LineSizeIn:Play()
	tweens.TitleTransparencyIn:Play()
	tweens.DescriptionTransparencyIn:Play()
	tweens.TitleTransparencyIn.Completed:Wait()
	if data.Enabled == true then
		data.Gui.Enabled = true
	end
end

function module:Disable()
	local data = self.Data
	local tweens = data.StoredTweens
	data.Gui.Enabled = false
	tweens.CircleTransparencyIn:Pause()
	tweens.LineSizeIn:Pause()
	tweens.TitleTransparencyIn:Pause()
	tweens.DescriptionTransparencyIn:Pause()

	tweens.CircleTransparencyOut:Play()
	tweens.LineSizeOut:Play()
	tweens.TitleTransparencyOut:Play()
	tweens.DescriptionTransparencyOut:Play()
	tweens.DescriptionTransparencyOut.Completed:Wait()
	if data.Enabled == false then
		data.Gui.Enabled = false
	end
end

return module