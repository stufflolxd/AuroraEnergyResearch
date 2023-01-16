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
end

return module