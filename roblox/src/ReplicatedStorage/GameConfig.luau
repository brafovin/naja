--!strict
-- GameConfig: Zentrale Werte, hier kannst du das Spiel tunen
return {
	-- Runde
	IntermissionSeconds = 8,
	RoundSeconds = 180,
	MinPlayersToStart = 1,

	-- Items
	ItemsToCollect = 5,
	ItemTag = "Collectible",

	-- Teddy
	TeddySpawnDelay = 10,
	TeddyWalkSpeed = 14,
	TeddyKillRange = 4,
	TeddyRepathInterval = 0.4,

	-- Tür / Exit
	ExitName = "ExitDoor",
	ExitOpenTime = 1.2,
}
