--!strict
-- TeddyAI: Pathfinding-basierte Jagd auf den nächsten Spieler
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local JumpscareEvent = Remotes:WaitForChild("Jumpscare") :: RemoteEvent

local TeddyAI = {}

local active: { [Model]: boolean } = {}

local function getClosestTarget(from: Vector3): (Player?, Model?, number)
	local bestPlayer: Player? = nil
	local bestChar: Model? = nil
	local bestDist = math.huge
	for _, player in Players:GetPlayers() do
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if root and hum and hum.Health > 0 then
			local d = (root.Position - from).Magnitude
			if d < bestDist then
				bestDist = d
				bestPlayer = player
				bestChar = char
			end
		end
	end
	return bestPlayer, bestChar, bestDist
end

function TeddyAI.start(teddy: Model, onKill: (Player) -> ())
	local humanoid = teddy:FindFirstChildOfClass("Humanoid")
	local root = teddy:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not humanoid or not root then
		warn("Teddy braucht Humanoid + HumanoidRootPart")
		return
	end
	humanoid.WalkSpeed = Config.TeddyWalkSpeed
	active[teddy] = true

	task.spawn(function()
		while active[teddy] and teddy.Parent and humanoid.Health > 0 do
			local player, char, dist = getClosestTarget(root.Position)
			if player and char and dist then
				-- Kill-Range Check
				if dist <= Config.TeddyKillRange then
					local victimHum = char:FindFirstChildOfClass("Humanoid")
					if victimHum then
						JumpscareEvent:FireClient(player)
						victimHum.Health = 0
						onKill(player)
						return
					end
				end

				-- Pathfinding zum Ziel
				local target = char:FindFirstChild("HumanoidRootPart") :: BasePart?
				if target then
					local path = PathfindingService:CreatePath({
						AgentRadius = 2,
						AgentHeight = 5,
						AgentCanJump = true,
					})
					local ok = pcall(function()
						path:ComputeAsync(root.Position, target.Position)
					end)
					if ok and path.Status == Enum.PathStatus.Success then
						local waypoints = path:GetWaypoints()
						for i = 2, math.min(#waypoints, 4) do
							if not active[teddy] then return end
							local wp = waypoints[i]
							if wp.Action == Enum.PathWaypointAction.Jump then
								humanoid.Jump = true
							end
							humanoid:MoveTo(wp.Position)
							humanoid.MoveToFinished:Wait()
						end
					else
						humanoid:MoveTo(target.Position)
					end
				end
			end
			task.wait(Config.TeddyRepathInterval)
		end
	end)
end

function TeddyAI.stop(teddy: Model)
	active[teddy] = nil
end

return TeddyAI
