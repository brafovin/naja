--!strict
-- Erstellt die RemoteEvents, die Server und Client zur Kommunikation nutzen
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local folder = Instance.new("Folder")
folder.Name = "Remotes"
folder.Parent = ReplicatedStorage

local function makeEvent(name: string)
	local ev = Instance.new("RemoteEvent")
	ev.Name = name
	ev.Parent = folder
end

makeEvent("StatusUpdate")     -- Server -> Client: Rundenstatus / Timer / Item-Count
makeEvent("Jumpscare")        -- Server -> Client: spielt Jumpscare ab
makeEvent("RoundResult")      -- Server -> Client: Sieg / Niederlage
