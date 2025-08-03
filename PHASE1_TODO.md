# Phase 1 - What Still Needs to Be Added for Basic Playability

## Critical Missing Features

### 1. **Actual Map File** ⚠️ CRITICAL
- Currently we only have area definitions but no actual map
- Need to create `/lobotomy-corp13/_maps/map_files/villains/villains_game.dmm`
- Should include:
  - 1 lobby area with spawn points
  - 1 main hall 
  - 10 individual rooms
  - Walls, floors, doors
  - Proper lighting

### 2. **Map Loading System** ⚠️ CRITICAL
- Need a way to load the villains map when game starts
- Options:
  - Create a separate z-level for the game
  - OR use a designated area on the main station
  - OR dynamically load the map when game starts

### 3. **Player Isolation/Ghost Handling**
- Dead players can still see everything and potentially metagame
- Need to:
  - Make eliminated players into ghosts
  - OR move them to a separate "dead player" area
  - Prevent dead players from communicating with living ones

### 4. **Voting System** 
- Currently villain just eliminates people with no counterplay
- Missing the core "vote out the villain" mechanic
- Need to add:
  - A way for players to call a vote
  - Voting UI or commands
  - Vote tallying
  - Consequences for wrong votes

### 5. **Round System**
- Game currently ends after one villain wins/loses
- No way to track scores across multiple rounds
- Need victory point tracking

### 6. **Communication Restrictions**
- Players can use all normal chat channels (OOC, radio, etc.)
- Need to restrict communication during the game
- Only allow local say/whisper

### 7. **Visual Feedback**
- No way to visually identify who's in the game
- No indication of game state
- Could add:
  - Special outfit/overlay for players
  - HUD element showing game status
  - Visual effects for elimination

### 8. **Spawn Protection**
- Players who join mid-game spawn in lobby
- They could interfere or be confused
  - Need to handle late joiners properly
  - Prevent non-players from entering game area

## Nice-to-Have Features

### 9. **Better Commands**
- `/villains-eliminate` is clunky
- Could add:
  - Right-click context menu for villain
  - Better target selection
  - Confirmation dialog

### 10. **Admin Controls**
- Add ability to:
  - Set specific villain
  - Revive eliminated players
  - Pause/resume game
  - Change minimum player count on the fly

### 11. **Automated Features**
- Auto-start when enough players
- Auto-end if too many disconnect
- Automatic area cleanup after game

### 12. **Polish**
- Sound effects for elimination
- Announcement formatting
- Better status display
- Game statistics/logs

## Minimum Required for Testing

To make Phase 1 actually testable with players, we MUST have:

1. **A map file** (even a simple box with rooms)
2. **Map loading** when game starts
3. **Ghost/death handling** to prevent metagaming
4. **Communication limits** (at least disable OOC during game)

## Suggested Quick Implementation

### Option A: Static Map Area
1. Add a villains game area to the main station map
2. Use existing map loading (no new system needed)
3. Just teleport players there

### Option B: Dynamic Map
1. Create a simple box map file
2. Load it to a new z-level when game starts
3. More complex but cleaner

### Option C: Virtual Game (No Map)
1. Keep players in place but add visual overlay
2. Disable movement during "night"
3. Use chat-based gameplay only
4. Least immersive but fastest to implement

## Code That Needs Adding

```dm
// Death handling
/datum/villains_simple_controller/proc/handle_death(mob/victim)
    victim.ghostize()
    // OR
    victim.forceMove(dead_player_area)
    
// Communication limits  
/datum/villains_simple_controller/proc/limit_communications()
    for(var/mob/M in players)
        M.client?.prefs.muted |= MUTE_OOC
        // etc

// Basic voting
/datum/villains_simple_controller/proc/start_vote()
/datum/villains_simple_controller/proc/cast_vote(mob/voter, mob/target)
/datum/villains_simple_controller/proc/tally_votes()
```

## Recommendation

Before moving to Phase 2, we should at minimum add:
1. Death handling (ghost or isolate dead players)
2. Communication restrictions
3. A basic map or use existing station area
4. Simple voting mechanic (even if just commands)

This would make the game actually playable and testable, rather than just technically functional.