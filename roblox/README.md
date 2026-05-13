# Naja Teddy – Roblox Horror-Escape

Ein "Teddy"-inspiriertes Spiel: Spieler sammeln gemeinsam Schlüssel in einem
dunklen Raum, während ein Killer-Teddy sie mit Pathfinding jagt. Sammelt
alle Schlüssel und flieht durch die Tür, bevor euch der Teddy erwischt.

## Spielablauf

1. **Pause (8s):** Wartezeit zwischen Runden
2. **Runde startet:** Schlüssel werden zufällig auf der Map verteilt
3. **Nach 10s:** Teddy spawnt und jagt den nächstgelegenen Spieler
4. **Sieg:** Alle Schlüssel gesammelt → Tür öffnet sich → durchlaufen
5. **Niederlage:** Teddy berührt dich oder Timer (3 min) läuft ab

## Setup in Roblox Studio

### 1. Map bauen

Erstelle im `Workspace` ein **Model** mit dem Namen `Map` und füge hinein:

| Objekt                | Typ      | Zweck                                    |
|-----------------------|----------|------------------------------------------|
| `ItemSpawns` (Ordner) | `Folder` | Enthält BaseParts als Schlüssel-Spawns   |
| `TeddySpawn`          | `Part`   | Hier spawnt der Teddy                    |
| `ExitDoor`            | `Part`   | Die Fluchttür (Anchored, CanCollide=on)  |

Tipp: Baue einen dunklen Raum mit Wänden, einigen Hindernissen und Räumen,
zwischen denen die Schlüssel verteilt werden. 8–15 Spawn-Punkte sind ideal.

### 2. Teddy-Rig erstellen

1. In Studio: **Avatar → Rig Builder → R15 Block Rig** einfügen
2. Den Rig in `ServerStorage` verschieben und in `Teddy` umbenennen
3. Optional: Parts dunkel einfärben, Gesicht mit Decal auftragen
4. Wichtig: Rig braucht `Humanoid` und `HumanoidRootPart` (kommt vom Rig Builder)
5. Setze `Humanoid.AutoRotate = true` und gib ihm `HumanoidStateType.Running`

### 3. Skripte einfügen

Kopiere die Dateien aus `src/` in die folgenden Studio-Services. Achte auf
den **Typ** (Script / LocalScript / ModuleScript) – das ergibt sich aus dem
Dateinamen:

| Datei                                | Ziel in Studio              | Typ           |
|--------------------------------------|-----------------------------|---------------|
| `ReplicatedStorage/GameConfig.luau`        | `ReplicatedStorage`     | ModuleScript  |
| `ReplicatedStorage/Remotes.server.luau`    | `ServerScriptService`*  | Script        |
| `ServerScriptService/GameManager.server.luau` | `ServerScriptService` | Script        |
| `ServerScriptService/TeddyAI.luau`         | `ServerScriptService`   | ModuleScript  |
| `StarterPlayerScripts/HUD.client.luau`     | `StarterPlayerScripts`  | LocalScript   |
| `StarterPlayerScripts/Jumpscare.client.luau` | `StarterPlayerScripts` | LocalScript   |

\* `Remotes.server.luau` erstellt zur Laufzeit den `Remotes`-Ordner in
`ReplicatedStorage`. Es muss vor den anderen Skripten laufen – einfachster
Weg: in `ServerScriptService` ablegen.

### 4. Lighting & Atmosphäre (optional, aber empfohlen)

Damit es sich nach Horror anfühlt, in `Lighting` einstellen:

- `Ambient` = (20, 20, 25)
- `OutdoorAmbient` = (10, 10, 15)
- `ClockTime` = 0 (Nacht)
- `FogEnd` = 60, `FogColor` = (10, 10, 12)
- Füge ein `Atmosphere` und/oder `ColorCorrectionEffect` (Saturation = -0.4) hinzu

## Tuning

Werte in `ReplicatedStorage/GameConfig.luau` anpassen – z.B.
`TeddyWalkSpeed`, `ItemsToCollect`, `RoundSeconds`. Änderungen wirken
automatisch beim nächsten Rundenstart.

## Erweiterungsideen

- **Fackel / Taschenlampe:** LocalScript mit `SpotLight` am Charakter
- **Verstecken:** Schrank-Modelle, die Spieler unsichtbar machen
- **Sound:** `Sound`-Objekte am Teddy für Herzschlag & Schritte
- **Mehrere Teddy-Typen:** Schnell vs. stark, Rotation per Runde
- **Shop:** mit `DataStoreService` Münzen sammeln und Skins kaufen
