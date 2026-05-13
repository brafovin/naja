--!strict
-- HUD: zeigt Rundenstatus, Timer, gesammelte Schlüssel
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StatusUpdate = Remotes:WaitForChild("StatusUpdate") :: RemoteEvent
local RoundResult = Remotes:WaitForChild("RoundResult") :: RemoteEvent

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TeddyHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function makeLabel(name: string, posY: number): TextLabel
	local lbl = Instance.new("TextLabel")
	lbl.Name = name
	lbl.AnchorPoint = Vector2.new(0.5, 0)
	lbl.Position = UDim2.new(0.5, 0, 0, posY)
	lbl.Size = UDim2.new(0, 360, 0, 36)
	lbl.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	lbl.BackgroundTransparency = 0.25
	lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 18
	lbl.Text = ""
	lbl.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = lbl
	return lbl
end

local statusLbl = makeLabel("Status", 16)
local itemsLbl = makeLabel("Items", 60)

StatusUpdate.OnClientEvent:Connect(function(data)
	if data.state == "Intermission" then
		statusLbl.Text = string.format("Nächste Runde in %ds", data.timeLeft)
		itemsLbl.Text = "Bereithalten..."
	elseif data.state == "Playing" then
		local m = math.floor(data.timeLeft / 60)
		local s = data.timeLeft % 60
		statusLbl.Text = string.format("Verbleibend: %d:%02d", m, s)
		itemsLbl.Text = string.format("Schlüssel: %d / %d", data.collected, data.needed)
	else
		statusLbl.Text = "Runde vorbei"
	end
end)

local function flashResult(text: string, color: Color3)
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.Size = UDim2.new(0, 520, 0, 120)
	frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	frame.BackgroundTransparency = 0.1
	frame.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = color
	lbl.Font = Enum.Font.GothamBlack
	lbl.TextSize = 30
	lbl.Parent = frame

	task.delay(3.5, function() frame:Destroy() end)
end

RoundResult.OnClientEvent:Connect(function(data)
	if data.victory then
		flashResult("GEFLOHEN! " .. data.message, Color3.fromRGB(110, 231, 160))
	else
		flashResult(data.message, Color3.fromRGB(239, 68, 68))
	end
end)
