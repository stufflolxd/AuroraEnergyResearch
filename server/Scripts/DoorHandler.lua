--[[

	// @server
	// FileName: DoorHandler.lua
	// Written by: tgarbrecht
	// Description: Handles doors on serverside.

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BridgeNet = require(ReplicatedStorage.Shared.BridgeNet)
local Remote = BridgeNet.CreateBridge("DoorBridge")

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
	Remote:Connect(function(plr, scripted)
		local attributes = scripted:GetAttributes()
		if attributes.Moving == false and plr:GetAttribute("Clearance") >= attributes.Clearance then
			if attributes.Class == "Vault Door" then
				if attributes.Open == false then
					scripted:SetAttribute("Moving", true)
					scripted.VaultAlarm.Spinnyspin.HingeConstraint.AngularVelocity = 5
					scripted.VaultAlarm.Spinnyspin.Alarm:Play()
					scripted.VaultAlarm.Flash.SpotLight.Enabled = true
					scripted.VaultAlarm.Flash.Material = Enum.Material.Neon
					scripted.Door.Noisey.Buzzer:Play()
					scripted.Door.Noisey.Lock:Play()
					task.wait(1.7)
					TweenModel(scripted.Door, scripted.OpenPos.CFrame, 15)
					task.wait(15)
					scripted.VaultAlarm.Spinnyspin.Alarm:Stop()
					scripted:SetAttribute("Moving", false)
					scripted:SetAttribute("Open", true)
				else
					scripted:SetAttribute("Moving", true)
					scripted.VaultAlarm.Spinnyspin.Alarm:Play()
					scripted.Door.Noisey.Buzzer:Play()
					TweenModel(scripted.Door, scripted.ClosedPos.CFrame, 15)
					task.wait(15)
					scripted.VaultAlarm.Spinnyspin.HingeConstraint.AngularVelocity = 0
					scripted.VaultAlarm.Spinnyspin.Alarm:Stop()
					scripted.VaultAlarm.Flash.SpotLight.Enabled = false
					scripted.VaultAlarm.Flash.Material = Enum.Material.SmoothPlastic
					scripted.Door.Noisey.Lock:Play()
					task.wait(1.7)
					scripted:SetAttribute("Moving", false)
					scripted:SetAttribute("Open", false)
				end
			end
		end
	end)
end

return module