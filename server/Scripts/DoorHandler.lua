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
			if attributes.Class == "Akkala Door" then
				
				local function SmonkOn()
					for i,v in pairs(scripted.Door:GetChildren()) do
						if v.Name == "Smonk" then
							v.ParticleEmitter.Enabled = true
						end
					end
				end
				
				local function SmonkOff()
					for i,v in pairs(scripted.Door:GetChildren()) do
						if v.Name == "Smonk" then
							v.ParticleEmitter.Enabled = false
						end
					end
				end
				
				if attributes.Open == false then
					scripted:SetAttribute("Moving", true)
					scripted.Door.Noise.Alarm:Play()
					task.wait(2)
					scripted.Door.Noise.Sound:Play()
					SmonkOn()
					TweenModel(scripted.Door.InnerRing, scripted.CFrameStuff["InnerRing_1"].CFrame, 2)
					task.wait(0.5)
					SmonkOff()
					task.wait(2.5)
					TweenModel(scripted.Door.OuterRing, scripted.CFrameStuff["OuterRing_1"].CFrame, 4)
					SmonkOn()
					task.wait(0.5)
					SmonkOff()
					task.wait(1.5)
					TweenModel(scripted.Door.InnerRing, scripted.CFrameStuff["InnerRing_2"].CFrame, 4.5)
					task.wait(4.5)
					SmonkOn()
					task.wait(0.7)
					SmonkOff()
					TweenModel(scripted.Door, scripted.CFrameStuff["MiddlePos"].CFrame, 1)
					task.wait(1)
					TweenModel(scripted.Door, scripted.CFrameStuff["HangPos"].CFrame, 11)
					task.wait(11)
					TweenModel(scripted.Door, scripted.CFrameStuff["OpenPos"].CFrame, 4)
					task.wait(5)
					scripted.Door.Noise.Alarm:Stop()
					scripted:SetAttribute("Moving", false)
					scripted:SetAttribute("Open", true)
				else
					scripted:SetAttribute("Moving", true)
					scripted.Door.Noise.Alarm:Play()
					scripted.Door.Noise.Close:Play()
					TweenModel(scripted.Door, scripted.CFrameStuff["MiddlePos"].CFrame, 11)
					task.wait(11)
					TweenModel(scripted.Door, scripted.CFrameStuff["ClosedPos"].CFrame, 1)
					task.wait(2)
					TweenModel(scripted.Door.InnerRing, scripted.CFrameStuff["InnerRing_Default"].CFrame, 4.5)
					task.wait(4.5)
					TweenModel(scripted.Door.OuterRing, scripted.CFrameStuff["OuterRing_Default"].CFrame, 4)
					task.wait(4)
					scripted.Door.Noise.Alarm:Stop()
					scripted:SetAttribute("Moving", false)
					scripted:SetAttribute("Open", false)
				end
			end
		end
	end)
end

return module