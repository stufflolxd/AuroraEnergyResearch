--[[

	// @local
	// FileName: DoorHandler.lua
	// Written by: tgarbrecht
	// Description: Renders the UI and renders the keypresses to fire to the server.

]]

local RunService = game:GetService("RunService")
local Highlights = {}
local EnabledHighlights = {}
local Billboards = {}
local EnabledBillboards = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BridgeNet = require(ReplicatedStorage.Shared.BridgeNet)
local Remote = BridgeNet.CreateBridge("DoorBridge")

local function ReturnPartInHighlightTable(Part)
	for _,v in pairs(EnabledHighlights) do
		if v.Data.Highlight == Part then
			return v
		end
	end
end

local function AddToHighlightTable(Highlight)
	table.insert(EnabledHighlights, Highlight)
end

local function ReverseAllHighlightTweens()
	spawn(function()
		for i,v in pairs(EnabledHighlights) do
			local a = v
			table.remove(EnabledHighlights, i)
			a:Disable()
		end
	end)
end

local function FindClassFromHighlightTable(Part)
	for _,v in pairs(Highlights) do
		if v.Data.Highlight == Part then
			return v
		end
	end
end




local function FindPart(Array, Part)
	for _,v in pairs(Array) do
		if v.Name == Part then
			return v
		end
	end
end




local function FindClassFromBillboardTable(Part)
	for _,v in pairs(Billboards) do
		if v.Data.Gui == Part then
			return v
		end
	end
end

local function AddToBillboardTable(Billboard)
	table.insert(EnabledBillboards, Billboard)
end

local function ReverseAllBillboardTweens()
	spawn(function()
		for i,v in pairs(EnabledBillboards) do
			local a = v
			table.remove(EnabledBillboards, i)
			a:Disable()
		end
	end)
end




local function TweenModel(model, cframe, time)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = model:GetPrimaryPartCFrame()

	CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
		model:SetPrimaryPartCFrame(CFrameValue.Value)
	end)

	local info = TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(CFrameValue, info, {Value = cframe})
	tween:Play()

	tween.Completed:Connect(function()
		CFrameValue:Destroy()
		tween:Destroy()
	end)
end

local module = {}

function module.Init()
	for i,v in pairs(game.Workspace.Scripted.Doors:GetDescendants()) do
		if v:IsA("Highlight") then
			local class = shared.Utility.Highlight.New(v)
			table.insert(Highlights, class)
		end
		if v:IsA("BillboardGui") and v.Name == "InteractionSystem" then
			local class = shared.Utility.InteractionUI.New(v)
			table.insert(Billboards, class)
		end
	end
	local plr = game.Players.LocalPlayer
	local debounce = false
	local inputdebounce = false
	RunService.Heartbeat:Connect(function()
		if debounce == false then
			local char = plr.Character
			if char ~= nil then
				local hrp = char:WaitForChild("HumanoidRootPart")
				local parts = workspace:GetPartBoundsInRadius(hrp.Position, 6)
				local part = FindPart(parts, "Activation_Sensory")
				if part then
					local scripted = part.Parent
					local class = scripted:GetAttribute("Class")
					if class == "Vault Door" then
						local highlight = scripted.Button.Highlight
						if ReturnPartInHighlightTable(highlight) then
						else
							debounce = true
							task.wait(0.1)
							
							local ButtonHighlight = FindClassFromHighlightTable(highlight)
							ButtonHighlight:Enable()
							AddToHighlightTable(ButtonHighlight)
							
							local DoorHighlight = FindClassFromHighlightTable(scripted.Door.Highlight)
							DoorHighlight:Enable()
							AddToHighlightTable(DoorHighlight)
							
							local Billboard = FindClassFromBillboardTable(scripted.Interaction_Sensory.InteractionSystem)
							Billboard:Enable()
							AddToBillboardTable(Billboard)
						end
					end
					debounce = false
				else
					ReverseAllHighlightTweens()
					ReverseAllBillboardTweens()
				end
			end
		end
	end)
	game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameProcessedEvent)
		if gameProcessedEvent then return end
		if inputObject.KeyCode == Enum.KeyCode.E then
			for i,v in pairs(EnabledBillboards) do
				local gui = v.Data.Gui
				local scripted = gui:FindFirstAncestor("Scripted")
				local attributes = scripted:GetAttributes()
				if plr:GetAttribute("Clearance") >= attributes.Clearance then
					Remote:Fire(scripted)
					if attributes.Class == "Vault Door" then
						if attributes.Moving == false and inputdebounce == false then
							local doorhighlight = scripted.Door.Highlight
							local buttonhighlight = scripted.Button.Highlight
							local interaction = FindClassFromBillboardTable(scripted.Interaction_Sensory.InteractionSystem)
							inputdebounce = true
							if attributes.Open == false then
								doorhighlight.FillColor = Color3.fromRGB(114, 255, 119)
								buttonhighlight.FillColor = Color3.fromRGB(114, 255, 119)
								interaction:Disable()
								task.wait(1.7)
								TweenModel(scripted.Door, scripted.OpenPos.CFrame, 15)
								task.wait(15)
								doorhighlight.FillColor = Color3.fromRGB(255, 255, 255)
								buttonhighlight.FillColor = Color3.fromRGB(255, 255, 255)
							else
								TweenModel(scripted.Door, scripted.ClosedPos.CFrame, 15)
								doorhighlight.FillColor = Color3.fromRGB(114, 255, 119)
								buttonhighlight.FillColor = Color3.fromRGB(114, 255, 119)
								interaction:Disable()
								task.wait(15)
								task.wait(1.7)
								doorhighlight.FillColor = Color3.fromRGB(255, 255, 255)
								buttonhighlight.FillColor = Color3.fromRGB(255, 255, 255)
							end
							task.wait(1)
							inputdebounce = false
						end
					end
				end
			end
		end
	end)
end

return module