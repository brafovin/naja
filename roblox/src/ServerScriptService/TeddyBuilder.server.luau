--!strict
-- TeddyBuilder: erzeugt einen einfachen dunklen Rig in ServerStorage,
-- falls noch keiner existiert. Du kannst ihn jederzeit durch einen
-- eigenen Rig (z.B. Toolbox-Modell) ersetzen – Hauptsache der Name ist "Teddy"
-- und er hat einen Humanoid + HumanoidRootPart.
local ServerStorage = game:GetService("ServerStorage")

if ServerStorage:FindFirstChild("Teddy") then return end

local DARK = Color3.fromRGB(35, 20, 20)
local EYE = Color3.fromRGB(220, 30, 30)

local model = Instance.new("Model")
model.Name = "Teddy"

local function part(name, size, color, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = Enum.Material.Fabric
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- Körper
local root = part("HumanoidRootPart", Vector3.new(2, 2, 1), DARK, model)
root.Transparency = 1
root.CanCollide = false

local torso = part("Torso", Vector3.new(2, 2, 1), DARK, model)
local head = part("Head", Vector3.new(1.6, 1.4, 1.6), DARK, model)
local leftArm = part("LeftArm", Vector3.new(1, 2, 1), DARK, model)
local rightArm = part("RightArm", Vector3.new(1, 2, 1), DARK, model)
local leftLeg = part("LeftLeg", Vector3.new(1, 2, 1), DARK, model)
local rightLeg = part("RightLeg", Vector3.new(1, 2, 1), DARK, model)

-- Positionierung
torso.CFrame = CFrame.new(0, 3, 0)
root.CFrame = torso.CFrame
head.CFrame = CFrame.new(0, 4.7, 0)
leftArm.CFrame = CFrame.new(-1.5, 3, 0)
rightArm.CFrame = CFrame.new(1.5, 3, 0)
leftLeg.CFrame = CFrame.new(-0.5, 1, 0)
rightLeg.CFrame = CFrame.new(0.5, 1, 0)

model.PrimaryPart = root

-- Motor6D Joints, damit der Humanoid laufen kann
local function joint(name, p0, p1, c0, c1)
	local m = Instance.new("Motor6D")
	m.Name = name
	m.Part0 = p0
	m.Part1 = p1
	m.C0 = c0
	m.C1 = c1
	m.Parent = p0
end

joint("RootJoint", root, torso, CFrame.new(0, 0, 0), CFrame.new(0, 0, 0))
joint("Neck", torso, head, CFrame.new(0, 1, 0), CFrame.new(0, -0.7, 0))
joint("LeftShoulder", torso, leftArm, CFrame.new(-1, 0.5, 0), CFrame.new(0.5, 0.5, 0))
joint("RightShoulder", torso, rightArm, CFrame.new(1, 0.5, 0), CFrame.new(-0.5, 0.5, 0))
joint("LeftHip", torso, leftLeg, CFrame.new(-0.5, -1, 0), CFrame.new(0, 1, 0))
joint("RightHip", torso, rightLeg, CFrame.new(0.5, -1, 0), CFrame.new(0, 1, 0))

-- Glühende Augen
local function eye(offset: Vector3)
	local e = Instance.new("Part")
	e.Name = "Eye"
	e.Size = Vector3.new(0.25, 0.25, 0.25)
	e.Color = EYE
	e.Material = Enum.Material.Neon
	e.Shape = Enum.PartType.Ball
	e.CanCollide = false
	e.Massless = true
	e.CFrame = head.CFrame * CFrame.new(offset)
	e.Parent = model

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = head
	weld.Part1 = e
	weld.Parent = e

	local light = Instance.new("PointLight")
	light.Brightness = 1.5
	light.Range = 6
	light.Color = EYE
	light.Parent = e
end
eye(Vector3.new(-0.35, 0.1, -0.81))
eye(Vector3.new(0.35, 0.1, -0.81))

-- Humanoid (sorgt für Laufen, Pathfinding-Steuerung)
local hum = Instance.new("Humanoid")
hum.RigType = Enum.HumanoidRigType.R6
hum.MaxHealth = math.huge
hum.Health = math.huge
hum.WalkSpeed = 14
hum.AutoRotate = true
hum.BreakJointsOnDeath = false
hum.Parent = model

-- Schritt-Sound (leise dumpfes Stampfen aus Roblox-Sound-IDs)
local sound = Instance.new("Sound")
sound.Name = "Footsteps"
sound.SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
sound.Looped = true
sound.Volume = 0.6
sound.Parent = root

model.Parent = ServerStorage
