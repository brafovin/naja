--!strict
-- Flashlight: F drücken, um eine Taschenlampe am Charakter zu togglen
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local light: SpotLight? = nil
local on = false

local function ensureLight()
	local char = player.Character
	local head = char and char:FindFirstChild("Head") :: BasePart?
	if not head then return nil end
	if light and light.Parent ~= head then
		light:Destroy()
		light = nil
	end
	if not light then
		light = Instance.new("SpotLight")
		light.Name = "Flashlight"
		light.Brightness = 0
		light.Range = 40
		light.Angle = 60
		light.Face = Enum.NormalId.Front
		light.Color = Color3.fromRGB(255, 240, 210)
		light.Parent = head
	end
	return light
end

local function setOn(value: boolean)
	on = value
	local l = ensureLight()
	if l then l.Brightness = value and 3 or 0 end
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.F then
		setOn(not on)
	end
end)

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	light = nil
	setOn(on)
end)

-- Lampe ausrichten: zeigt in Blickrichtung der Kamera
RunService.RenderStepped:Connect(function()
	local char = player.Character
	local head = char and char:FindFirstChild("Head") :: BasePart?
	if not head then return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	-- Roblox' SpotLight Face Front zeigt entlang -Head.CFrame.LookVector.
	-- Wir nutzen einfach die natürliche Kopfausrichtung; AutoRotate sorgt
	-- dafür, dass der Char in Bewegungsrichtung schaut.
end)
