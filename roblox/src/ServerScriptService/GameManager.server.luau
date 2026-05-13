--!strict
-- GameManager: Rundenablauf, Item-Spawn, Sieg-/Niederlage-Bedingungen
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local StatusUpdate = Remotes:WaitForChild("StatusUpdate") :: RemoteEvent
local RoundResult = Remotes:WaitForChild("RoundResult") :: RemoteEvent

local TeddyAI = require(script.Parent:WaitForChild("TeddyAI"))

type Round = {
	state: "Intermission" | "Playing" | "Ending",
	collected: number,
	timeLeft: number,
	teddy: Model?,
}

local round: Round = {
	state = "Intermission",
	collected = 0,
	timeLeft = Config.IntermissionSeconds,
	teddy = nil,
}

local function getMap(): Model
	local map = Workspace:FindFirstChild("Map")
	assert(map and map:IsA("Model"), "Erstelle in Workspace ein Model namens 'Map'")
	return map
end

local function getItemSpawns(): {BasePart}
	local map = getMap()
	local folder = map:FindFirstChild("ItemSpawns")
	assert(folder, "Map braucht einen Ordner 'ItemSpawns' mit Parts als Spawn-Punkte")
	local out = {}
	for _, child in folder:GetChildren() do
		if child:IsA("BasePart") then table.insert(out, child) end
	end
	return out
end

local function getTeddySpawn(): BasePart
	local map = getMap()
	local spawn = map:FindFirstChild("TeddySpawn")
	assert(spawn and spawn:IsA("BasePart"), "Map braucht einen Part 'TeddySpawn'")
	return spawn
end

local function getExitDoor(): BasePart
	local map = getMap()
	local door = map:FindFirstChild(Config.ExitName)
	assert(door and door:IsA("BasePart"), "Map braucht einen Part '" .. Config.ExitName .. "'")
	return door
end

local function broadcastStatus()
	StatusUpdate:FireAllClients({
		state = round.state,
		collected = round.collected,
		needed = Config.ItemsToCollect,
		timeLeft = round.timeLeft,
	})
end

local function clearItems()
	for _, item in CollectionService:GetTagged(Config.ItemTag) do
		item:Destroy()
	end
end

local function spawnItems()
	clearItems()
	local spawns = getItemSpawns()
	local picked = {}
	local count = math.min(Config.ItemsToCollect, #spawns)
	while #picked < count do
		local idx = math.random(1, #spawns)
		if not table.find(picked, idx) then
			table.insert(picked, idx)
		end
	end
	for _, idx in picked do
		local s = spawns[idx]
		local key = Instance.new("Part")
		key.Name = "KeyItem"
		key.Size = Vector3.new(1.4, 0.5, 1.4)
		key.Material = Enum.Material.Neon
		key.Color = Color3.fromRGB(255, 215, 60)
		key.Anchored = true
		key.CanCollide = false
		key.CFrame = s.CFrame + Vector3.new(0, 1.5, 0)
		key.Parent = Workspace
		CollectionService:AddTag(key, Config.ItemTag)

		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Aufheben"
		prompt.ObjectText = "Schlüssel"
		prompt.HoldDuration = 0.6
		prompt.MaxActivationDistance = 8
		prompt.Parent = key
	end
end

local function openExit()
	local door = getExitDoor()
	local goal = { Transparency = 0.7, CanCollide = false }
	local tween = TweenService:Create(door, TweenInfo.new(Config.ExitOpenTime), goal)
	tween:Play()
end

local function closeExit()
	local door = getExitDoor()
	door.Transparency = 0
	door.CanCollide = true
end

local function endRound(victory: boolean, message: string)
	if round.state == "Ending" then return end
	round.state = "Ending"
	if round.teddy then
		TeddyAI.stop(round.teddy)
		round.teddy:Destroy()
		round.teddy = nil
	end
	clearItems()
	closeExit()
	RoundResult:FireAllClients({ victory = victory, message = message })
	broadcastStatus()

	for _, player in Players:GetPlayers() do
		if player.Character then
			player:LoadCharacter()
		end
	end
end

local function startRound()
	round.state = "Playing"
	round.collected = 0
	round.timeLeft = Config.RoundSeconds
	closeExit()
	spawnItems()
	broadcastStatus()

	for _, player in Players:GetPlayers() do
		player:LoadCharacter()
	end

	task.delay(Config.TeddySpawnDelay, function()
		if round.state ~= "Playing" then return end
		local template = ServerStorage:FindFirstChild("Teddy")
		if not template or not template:IsA("Model") then
			warn("ServerStorage.Teddy fehlt – erstelle eine Rig mit Humanoid und nenne sie 'Teddy'")
			return
		end
		local teddy = template:Clone()
		teddy:PivotTo(getTeddySpawn().CFrame + Vector3.new(0, 3, 0))
		teddy.Parent = Workspace
		round.teddy = teddy
		TeddyAI.start(teddy, function(victim)
			endRound(false, victim.Name .. " wurde gefangen!")
		end)
	end)
end

-- Item aufgehoben: gilt für jeden Spieler, kooperatives Sammeln
local function onPromptTriggered(prompt: ProximityPrompt, player: Player)
	local parent = prompt.Parent
	if not parent or not parent:IsA("BasePart") then return end
	if not CollectionService:HasTag(parent, Config.ItemTag) then return end
	if round.state ~= "Playing" then return end
	parent:Destroy()
	round.collected += 1
	broadcastStatus()
	if round.collected >= Config.ItemsToCollect then
		openExit()
	end
end

game:GetService("ProximityPromptService").PromptTriggered:Connect(onPromptTriggered)

-- Sieg: Spieler berührt offene Tür
task.spawn(function()
	while true do
		task.wait(0.25)
		if round.state == "Playing" and round.collected >= Config.ItemsToCollect then
			local door = getExitDoor()
			if door.CanCollide == false then
				for _, player in Players:GetPlayers() do
					local char = player.Character
					local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
					if root and (root.Position - door.Position).Magnitude < 6 then
						endRound(true, "Geflohen!")
						break
					end
				end
			end
		end
	end
end)

-- Haupt-Loop: Pause -> Runde -> Pause
task.spawn(function()
	while true do
		round.state = "Intermission"
		round.timeLeft = Config.IntermissionSeconds
		broadcastStatus()
		while round.timeLeft > 0 do
			task.wait(1)
			round.timeLeft -= 1
			broadcastStatus()
		end

		if #Players:GetPlayers() < Config.MinPlayersToStart then
			continue
		end

		startRound()
		while round.state == "Playing" and round.timeLeft > 0 do
			task.wait(1)
			round.timeLeft -= 1
			broadcastStatus()
		end
		if round.state == "Playing" then
			endRound(false, "Zeit abgelaufen – der Teddy bleibt...")
		end
		task.wait(4)
	end
end)
