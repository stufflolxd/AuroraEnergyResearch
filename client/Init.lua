--[[

	// @local
	// FileName: Init.lua
	// Written by: tgarbrecht
	// Description: Runs the init function to initiate all local scripts on the client.

]]

local Module = {}

function Module.Init()
	warn("Initializing...")
	for i,v in pairs(script.Parent.PreLoaded:GetChildren()) do
		if v:IsA("ModuleScript") then
			local t = tick()
			print("Preloading: "..v.Name)
			require(v).Init()
			print("Done in "..tick()-t)
		end
	end
	for i,v in pairs(script.Parent.Classes:GetChildren()) do
		if v:IsA("ModuleScript") then
			shared.Utility[v.Name] = require(v)
			print("Class: "..v.Name.." set.")
		end
	end
	for i,v in pairs(script.Parent.Scripts:GetChildren()) do
		if v:IsA("ModuleScript") then
			require(v).Init()
			print("Module: "..v.Name.." set.")
		end
	end
	warn("Initialization complete!")
end

return Module