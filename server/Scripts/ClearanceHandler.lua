--[[

	// @server
	// FileName: ClearanceHandler.lua
	// Written by: tgarbrecht
	// Description: Creates clearances for players. This is just because I'm unsure if cesar will want clearances.

]]

local Group = 15873663

local ClearanceList = {
	["3"] = 254,
	["2"] = 3,
	["1"] = 2,
	["0"] = 0
}

local function ReturnClearance(plr)
	local rank = plr:GetRankInGroup(Group)
	local highestrank = 0
	for i,v in pairs(ClearanceList) do
		if rank >= v and highestrank <= v then
			highestrank = v
		end
	end
	for i,v in pairs(ClearanceList) do
		if highestrank == v then
			return i
		end
	end
end

local module = {}

function module.Init()
	game.Players.PlayerAdded:Connect(function(plr)
		local clearance = ReturnClearance(plr)
		plr:SetAttribute("Clearance", clearance)
	end)
end

return module