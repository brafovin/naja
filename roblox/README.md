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

**Gute Nachricht:** Map, Teddy-Rig und Horror-Atmosphäre werden zur Laufzeit
automatisch erzeugt. Du musst nur die Skripte einfügen und kannst sofort spielen.
Eigene Map / eigenen Rig nutzen? Einfach manuell in Workspace bzw. ServerStorage
ablegen – die Auto-Builder sehen das und überspringen die Erstellung.

### Skripte einfügen

Kopiere die Dateien aus `src/` in die folgenden Studio-Services. Achte auf
den **Typ** (Script / LocalScript / ModuleScript) – das ergibt sich aus dem
Dateinamen:

| Datei                                              | Ziel in Studio          | Typ           |
|----------------------------------------------------|-------------------------|---------------|
| `ReplicatedStorage/GameConfig.luau`                | `ReplicatedStorage`     | ModuleScript  |
| `ReplicatedStorage/Remotes.server.luau`            | `ServerScriptService`*  | Script        |
| `ServerScriptService/MapBuilder.server.luau`       | `ServerScriptService`   | Script        |
| `ServerScriptService/TeddyBuilder.server.luau`     | `ServerScriptService`   | Script        |
| `ServerScriptService/Atmosphere.server.luau`       | `ServerScriptService`   | Script        |
| `ServerScriptService/GameManager.server.luau`      | `ServerScriptService`   | Script        |
| `ServerScriptService/TeddyAI.luau`                 | `ServerScriptService`   | ModuleScript  |
| `StarterPlayerScripts/HUD.client.luau`             | `StarterPlayerScripts`  | LocalScript   |
| `StarterPlayerScripts/Jumpscare.client.luau`       | `StarterPlayerScripts`  | LocalScript   |
| `StarterPlayerScripts/Flashlight.client.luau`      | `StarterPlayerScripts`  | LocalScript   |

\* `Remotes.server.luau` erstellt zur Laufzeit den `Remotes`-Ordner in
`ReplicatedStorage`. Einfachster Weg: in `ServerScriptService` ablegen.

### Features

- **Auto-Map:** dunkler Labyrinth-Raum mit Spawn-Punkten, Teddy-Spawn und Exit
- **Auto-Teddy:** schwarze Rig mit glühenden roten Augen + Schritt-Sound
- **Horror-Lighting:** Nacht, Nebel, Sättigung runter, Bloom, Atmosphäre
- **Taschenlampe:** `F` zum Togglen
- **Spectator-Modus:** wer stirbt, bleibt tot bis die Runde endet
- **Jumpscare:** roter Vollbild-Flash + Kamera-Shake
- **HUD:** Timer + Schlüsselzähler oben am Bildschirm

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
