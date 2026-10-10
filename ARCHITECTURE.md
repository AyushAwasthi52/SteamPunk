# Architecture

## 1. Engine and Standards
- **Engine**: Godot 4.3 (Forward Plus)
- **Language**: GDScript 2.0
- **Conventions**: 
  - Use typed variables where practical (e.g., `var speed: float = 200.0`).
  - Keep relative paths for resources.
  - Connect systems primarily through Signals to avoid tight coupling.

## 2. Directory Structure
```
res://
├── levels/
│   ├── MainLevel.tscn
│   └── MainLevel.gd
├── player/
│   ├── Player.tscn
│   └── Player.gd
├── objects/
│   ├── InteractableCounter.tscn
│   └── InteractableCounter.gd
├── ui/
│   ├── HUD.tscn
│   └── HUD.gd
```

## 3. Core Components

### Player
- `CharacterBody2D` configured for top-down movement.
- Handles its own movement logic using `move_and_slide()`.
- Broadcasts its interaction intents or uses an `Area2D` to overlap interactables.

### Interactable
- Counters and desks use an `Area2D` to detect player presence.
- Uses signals to inform the HUD to show an "Interact" prompt.
- Executes specific logic (updating objective, showing dialogue) when interacted with.

### HUD
- An independent `CanvasLayer` that listens to global state changes or signals from interactables/player to update text.
- Separates UI rendering from gameplay logic.
