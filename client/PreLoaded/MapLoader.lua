--[[

	// @local
	// FileName: MapLoader.lua
	// Written by: tgarbrecht
	// Description: Preloads the map on the client so the server doesn't have to render. See /serversrc/PreLoaded/Map.lua

]]

local module = {}

function module.Init()
	local ContentProvider = game:GetService("ContentProvider")
	local Map = game.ReplicatedStorage:WaitForChild("Map")
	Map.Parent = workspace
	ContentProvider:PreloadAsync({Map})
end

return module