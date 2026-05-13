--!strict
-- MapBuilder: erzeugt automatisch eine spielbare Beispiel-Map, falls keine
-- existiert. Du kannst sie jederzeit durch eine eigene Map ersetzen, solange
-- die Struktur (Model "Map" mit ItemSpawns/TeddySpawn/ExitDoor) erhalten bleibt.
local Workspace = game:GetService("Workspace")

if Workspace:FindFirstChild("Map") then return end

local FLOOR_SIZE = Vector3.new(160, 1, 160)
local WALL_HEIGHT = 18
local WALL_THICKNESS = 2
local ROOM_COLOR = Color3.fromRGB(45, 38, 35)
local WALL_COLOR = Color3.fromRGB(28, 22, 22)

local map = Instance.new("Model")
map.Name = "Map"

local function part(name: string, size: Vector3, cf: CFrame, color: Color3, parent: Instance)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Anchored = true
	p.Color = color
	p.Material = Enum.Material.Concrete
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- Boden
local floor = part("Floor", FLOOR_SIZE, CFrame.new(0, 0, 0), ROOM_COLOR, map)
floor.Material = Enum.Material.WoodPlanks

-- Decke
part("Ceiling", FLOOR_SIZE, CFrame.new(0, WALL_HEIGHT + 0.5, 0), WALL_COLOR, map)

-- Aussenwände (mit Lücke für die Tür in der Nord-Wand)
local hx = FLOOR_SIZE.X / 2
local hz = FLOOR_SIZE.Z / 2
local wy = WALL_HEIGHT / 2 + 0.5

-- Nord-Wand mit Lücke für Exit (Lücke 8 wide, mittig)
local gap = 8
local segLen = (FLOOR_SIZE.X - gap) / 2
part("WallN1", Vector3.new(segLen, WALL_HEIGHT, WALL_THICKNESS),
	CFrame.new(-(gap/2 + segLen/2), wy, -hz), WALL_COLOR, map)
part("WallN2", Vector3.new(segLen, WALL_HEIGHT, WALL_THICKNESS),
	CFrame.new(gap/2 + segLen/2, wy, -hz), WALL_COLOR, map)

part("WallS", Vector3.new(FLOOR_SIZE.X, WALL_HEIGHT, WALL_THICKNESS),
	CFrame.new(0, wy, hz), WALL_COLOR, map)
part("WallW", Vector3.new(WALL_THICKNESS, WALL_HEIGHT, FLOOR_SIZE.Z),
	CFrame.new(-hx, wy, 0), WALL_COLOR, map)
part("WallE", Vector3.new(WALL_THICKNESS, WALL_HEIGHT, FLOOR_SIZE.Z),
	CFrame.new(hx, wy, 0), WALL_COLOR, map)

-- Innere Wände als Labyrinth-Hindernisse
local function innerWall(name, size, x, z)
	part(name, Vector3.new(size.X, WALL_HEIGHT, size.Z),
		CFrame.new(x, wy, z), WALL_COLOR, map)
end

innerWall("Inner1", Vector3.new(40, 0, 2), -30, -30)
innerWall("Inner2", Vector3.new(2, 0, 30), -10, -15)
innerWall("Inner3", Vector3.new(50, 0, 2), 20, 10)
innerWall("Inner4", Vector3.new(2, 0, 40), 45, 20)
innerWall("Inner5", Vector3.new(30, 0, 2), -40, 30)
innerWall("Inner6", Vector3.new(2, 0, 25), -55, 50)
innerWall("Inner7", Vector3.new(35, 0, 2), 25, -40)
innerWall("Inner8", Vector3.new(2, 0, 20), 5, 50)

-- Item-Spawns: kleine Marker an verstreuten Positionen
local spawnsFolder = Instance.new("Folder")
spawnsFolder.Name = "ItemSpawns"
spawnsFolder.Parent = map

local spawnPositions = {
	Vector3.new(-55, 1.5, -60),
	Vector3.new(60, 1.5, -55),
	Vector3.new(-65, 1.5, 60),
	Vector3.new(55, 1.5, 65),
	Vector3.new(0, 1.5, 0),
	Vector3.new(-30, 1.5, 20),
	Vector3.new(35, 1.5, -10),
	Vector3.new(-15, 1.5, 55),
	Vector3.new(70, 1.5, 30),
	Vector3.new(-70, 1.5, -20),
	Vector3.new(20, 1.5, -65),
	Vector3.new(50, 1.5, 50),
}
for i, pos in spawnPositions do
	local marker = Instance.new("Part")
	marker.Name = "Spawn" .. i
	marker.Size = Vector3.new(2, 0.2, 2)
	marker.Anchored = true
	marker.CanCollide = false
	marker.Transparency = 1
	marker.CFrame = CFrame.new(pos)
	marker.Parent = spawnsFolder
end

-- Teddy-Spawn weit weg vom Player-Spawn
local teddySpawn = part("TeddySpawn", Vector3.new(4, 0.2, 4),
	CFrame.new(0, 1, hz - 6), Color3.fromRGB(120, 20, 20), map)
teddySpawn.Transparency = 1
teddySpawn.CanCollide = false

-- Exit-Tür: anfangs geschlossen
local door = part("ExitDoor", Vector3.new(gap, WALL_HEIGHT - 2, WALL_THICKNESS),
	CFrame.new(0, wy, -hz), Color3.fromRGB(110, 60, 30), map)
door.Material = Enum.Material.WoodPlanks

-- Außenbereich (kleiner Flucht-Vorraum), damit man sieht, dass man entkommen ist
part("EscapePad", Vector3.new(20, 1, 16),
	CFrame.new(0, 0, -hz - 10), Color3.fromRGB(60, 80, 50), map).Material = Enum.Material.Grass

-- Spieler-Spawn (Spawn Location) in einer der Ecken
local spawnLoc = Instance.new("SpawnLocation")
spawnLoc.Name = "PlayerSpawn"
spawnLoc.Size = Vector3.new(6, 1, 6)
spawnLoc.Anchored = true
spawnLoc.CanCollide = true
spawnLoc.CFrame = CFrame.new(-hx + 10, 1, hz - 10)
spawnLoc.BrickColor = BrickColor.new("Really black")
spawnLoc.Material = Enum.Material.Slate
spawnLoc.Parent = map

map.Parent = Workspace
