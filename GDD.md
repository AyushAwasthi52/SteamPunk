# Ministry of Mechanical Affairs

## 1. Premise
You are a junior clerk in a catastrophically inefficient steampunk government ministry. Your sole objective is to obtain a permit to operate a steam-powered machine before the Ministry closes.

## 2. Core Gameplay Loop
1. Receive an objective (e.g., "Obtain Permit Form 27-B").
2. Navigate the Ministry floor, bypassing mechanical queues and overengineered obstacles.
3. Locate the appropriate bureaucratic counter or machine.
4. Interact to receive the form, stamp, or signature.
5. Receive the next absurd requirement (e.g., "Take Form 27-B to Desk 4 for counter-stamping").
6. Repeat until the final "permit" is obtained.

## 3. Controls
- **Movement**: W, A, S, D (or Arrow Keys)
- **Interact**: E (or Space/Enter)

## 4. Scene Structure
- **MainLevel**: The root scene for the game world. Contains the floor, walls, and gameplay objects.
- **Player**: A `CharacterBody2D` scene representing the clerk.
- **Interactables**: A generic structure for counters, desks, and machines, using `Area2D` for proximity detection.
- **HUD**: A `CanvasLayer` scene displaying current objectives and interaction prompts.

## 5. Systems
- **Interaction System**: Detects nearby interactables and triggers their logic when the interact button is pressed.
- **Objective System**: Tracks the player's current bureaucratic goal and updates the HUD.
- **Dialogue/Notification System**: Displays short, humorous text when interacting with clerks or reading signs.

## 6. Implementation Milestones
- [x] Phase 1: Establish project foundation.
- [ ] Phase 2: Build the first playable prototype (Movement, Interaction, HUD).
- [ ] Phase 3: Add sequential objectives and multiple counters.
- [ ] Phase 4: Polish visuals (blueprint style, brass accents).
- [ ] Phase 5: Add audio (clock ticking, steam hisses, stamp thuds).
- [ ] Phase 6: Final balance and comedy tuning.
