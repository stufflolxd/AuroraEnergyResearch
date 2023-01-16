--[[

	// @server
	// FileName: Init.lua
	// Written by: tgarbrecht
	// Description: Runs the init function to initiate all server scripts on the server.

]]

local Module = {}

function Module.Init()
	for i,v in pairs(script.Parent.PreLoaded:GetChildren()) do
		if v:IsA("ModuleScript") then
			require(v).Init()
		end
	end
	for i,v in pairs(script.Parent.Classes:GetChildren()) do
		if v:IsA("ModuleScript") then
			_G[v.Name] = require(v)
		end
	end
	for i,v in pairs(script.Parent.Scripts:GetChildren()) do
		if v:IsA("ModuleScript") then
			require(v).Init()
		end
	end
end

return Module