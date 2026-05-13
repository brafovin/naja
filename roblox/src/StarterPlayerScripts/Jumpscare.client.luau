--!strict
-- Jumpscare: roter Vollbild-Effekt, wenn der Teddy zuschlägt
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Jumpscare = Remotes:WaitForChild("Jumpscare") :: RemoteEvent

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Jumpscare"
gui.DisplayOrder = 100
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

Jumpscare.OnClientEvent:Connect(function()
	local flash = Instance.new("Frame")
	flash.Size = UDim2.fromScale(1, 1)
	flash.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
	flash.BackgroundTransparency = 0
	flash.ZIndex = 50
	flash.Parent = gui

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Text = "ERWISCHT!"
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Font = Enum.Font.GothamBlack
	lbl.TextSize = 96
	lbl.TextStrokeTransparency = 0
	lbl.ZIndex = 51
	lbl.Parent = flash

	local fade = TweenService:Create(flash, TweenInfo.new(1.6), { BackgroundTransparency = 1 })
	local fadeLbl = TweenService:Create(lbl, TweenInfo.new(1.6), { TextTransparency = 1, TextStrokeTransparency = 1 })
	fade:Play()
	fadeLbl:Play()
	task.delay(1.8, function() flash:Destroy() end)

	-- kleiner Kamera-Shake
	local cam = workspace.CurrentCamera
	if cam then
		local start = tick()
		while tick() - start < 0.6 do
			cam.CFrame = cam.CFrame * CFrame.Angles(
				math.rad((math.random() - 0.5) * 4),
				math.rad((math.random() - 0.5) * 4),
				math.rad((math.random() - 0.5) * 4)
			)
			task.wait()
		end
	end
end)
