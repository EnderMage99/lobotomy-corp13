# Phase 1: Minimal Playable Game - COMPLETE

## Implementation Summary

Phase 1 of the Villains game has been successfully implemented with all core features:

### Files Created
1. `/lobotomy-corp13/code/modules/villains/controller_simple.dm` - Main game controller
2. `/lobotomy-corp13/code/modules/villains/commands.dm` - Player commands and admin verbs
3. `/lobotomy-corp13/code/modules/villains/areas.dm` - Game area definitions

### Features Implemented

#### Game Controller (`/datum/villains_simple_controller`)
- Player management (add/remove players from lobby)
- Minimum players required to start (set to 2 for testing, should be 6 for real games)
- Random villain selection
- Game state tracking (lobby, playing, ended)
- Elimination mechanics
- Win condition checking (villain wins when 2 or fewer players remain)
- Announcements to all players
- Automatic teleportation to game area when joining
- Spawn point management for lobby and rooms

#### Areas Created
- **Villains Game Lobby** - Where players gather before game starts
- **Villains Main Hall** - Central game area
- **Villains Rooms 1-10** - Individual rooms for players

#### Player Commands
- `/villains-eliminate` - Eliminate a player (villain only, regular verb)

#### Admin Commands (Admin > Fun menu)
- **Join Villains Game** - Join the game lobby
- **Leave Villains Game** - Leave the game
- **Villains Game Status** - Check game status and see who's alive/dead
- **Add Player to Villains Game** - Add another player to the game
- **Start Villains Game** - Start the game (needs minimum players)
- **Force End Villains Game** - Force end the current game

### How to Test

1. **Setup**
   - Make sure villains areas exist on the map (or players will spawn at their current location)
   - Admins should have access to the Fun menu

2. **Join the Game**
   - Admin uses "Join Villains Game" from Admin > Fun menu
   - Players are automatically teleported to the villains lobby area
   - Players see join announcements
   - Admin can add other players using "Add Player to Villains Game"

3. **Start the Game**
   - Once 2+ players join (lowered for testing), admin uses "Start Villains Game"
   - One player is randomly selected as villain
   - Villain sees red message, others see blue message

4. **Elimination**
   - Villain uses `/villains-eliminate` command
   - Selects target from dropdown
   - Target is eliminated and all players notified

5. **Check Status**
   - Admin uses "Villains Game Status" to see:
     - Game active status
     - Current phase
     - Who is alive/dead
     - Whether they are villain or innocent

6. **Win Conditions**
   - Villain wins when only 2 players remain alive
   - Game automatically ends and announces villain

### Important Notes
- The game will work without a dedicated map, but players won't be teleported
- For full functionality, villains areas should be added to the station map
- Minimum players is set to 2 for testing (change back to 6 for production)
- All commands except `/villains-eliminate` are admin-only for controlled testing

### Next Steps (Phase 2)
- Add day/night cycle system
- Implement phase transitions
- Add movement restrictions during night
- Create action selection UI
- Add proper map with defined areas

### Testing Checklist
- [x] Game controller created
- [x] Admin verbs added to Fun menu
- [x] Player join/leave functionality
- [x] Villain selection works
- [x] Elimination mechanics work
- [x] Win/loss detection works
- [x] Area definitions created
- [x] Spawn point system implemented
- [x] Admin can add other players
- [x] All files added to DME