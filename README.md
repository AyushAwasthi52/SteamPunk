# Ministry of Mechanical Affairs

**Team Name:** Procastinators

## Game Description
*Ministry of Mechanical Affairs* is a top-down, steampunk-themed puzzle and "inconvenience simulator." The player takes on the role of a citizen desperately trying to obtain a simple permit from a highly bureaucratic government office before the 8-minute timer runs out. 

To achieve this, the player must navigate a sprawling, absurdly complex network of administrative tasks: taking a queue ticket, getting the correct forms, physically pumping a steam boiler to power the pneumatic stamps, shredding obsolete forms, waking up sleeping notaries, and dragging 200lb ink barrels across the floor. Oh, and you must do all of this while avoiding the patrolling Inspector, who will aggressively fine you for "running" and confiscate your paperwork.

## Theme Implementation
**Theme:** Steampunk Bureaucracy / Worst Game Wins

The game heavily incorporates the steampunk theme through its aesthetic and mechanics. The visual style utilizes crisp blueprint technical grids contrasted with rich brass and copper mechanical assets (huge steam boilers, pneumatic tubes, and intricate gears). Mechanically, the steampunk theme is represented through the physical labor required for bureaucracy (e.g., manually pumping a boiler to restore pressure for a stamp, or hauling a massive cast-iron ink barrel).

## Intentional Bad Design Choices
This game was built from the ground up to be a perfectly functioning engine of misery, directly aligning with the "Worst Game Wins" prompt. The bad design choices are systematic, intentional, and deeply committed to the bit:

1. **The Control Scrambler:** Every 12 seconds, the WASD movement keys are completely randomized. The player's sprite flashes red to indicate the shift. Just as you get used to the new controls, they scramble again, severely hindering player agency.
2. **Extreme Encumbrance:** Carrying certain quest items (like forms) drops your movement speed by 80%. Fetching the Notary's "Blue Ink Pen" (which is actually a 200lb iron barrel) drops your speed down to a crawl of just 20 pixels per second. 
3. **The Queue System:** Players are forced to take a ticket and physically wait in real-time as the "Now Serving" counter slowly ticks up. If the player approaches the desk too early, they are rejected. If they miss their turn by a single number, their ticket is invalidated and they must go back to the dispenser and wait in line again.
4. **The Inspector:** An NPC endlessly patrols the center of the room. If the player touches him, they are penalized with a 15-second time deduction, and any paperwork they are holding is instantly confiscated—forcing them to restart the entire sequence from the very beginning of the queue.
5. **Bell Mashing:** To wake up the Notary, the player must walk over to a call bell and mash the interact key exactly 20 times. 
6. **Fake Objectives:** Halfway through the game, the player discovers the form they just spent minutes getting stamped was made obsolete at noon. They are forced to shred it and start over for a "Rev2" form.

## How to Play
1. Run the executable file (`MinistryOfMechanicalAffairs.exe` or equivalent).
2. Move using `W, A, S, D` (Warning: These will scramble frequently).
3. Press `E` to interact with desks, machines, and the call bell.
4. Follow the current Objective shown in the top-left corner of the screen.
5. Do not let the timer reach zero.
6. Good luck. You will need it.
