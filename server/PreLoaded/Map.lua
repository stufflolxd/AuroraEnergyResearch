--[[

	// @server
	// FileName: Map.lua
	// Written by: tgarbrecht
	// Description: Puts the map into ReplicatedStorage so the server doesn't have to render the map, however the client can still retrieve the map.

]]

local module = {}

function module.Init()
	workspace.Map.Parent = game.ReplicatedStorage
end

return module