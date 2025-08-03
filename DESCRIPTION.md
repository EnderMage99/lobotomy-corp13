# Villains of the Night - Simplified Design

## Overview
A streamlined social deduction game for 6-10 players. One player is secretly the villain each round trying to eliminate others. Players vote to identify the villain and earn victory points.

## Core Game Loop
1. **Day Phase** (5 minutes) - Players explore, collect items, and talk
2. **Night Phase** (2 minutes) - Players choose actions in their rooms
3. **Trial Phase** (5 minutes) - If someone died, players investigate and vote
4. **Next Round** - New villain selected, continue until <5 players

## Victory System
- **Correct Vote**: +1 victory point (villain caught)
- **Wrong Vote**: -1 victory point (innocent blamed)
- **Game End**: When <5 players remain
- **Winners**: Players with 1+ points win

## Simplified Characters (8 Total)

### 1. **Detective** (Investigative)
- **Ability**: See who visited target player
- **Strategy**: Track movement patterns

### 2. **Guardian** (Protective)  
- **Ability**: Protect target from elimination
- **Strategy**: Keep key players alive

### 3. **Spy** (Investigative)
- **Ability**: See target's item inventory
- **Strategy**: Track item usage

### 4. **Saboteur** (Disruptive)
- **Ability**: Block target's action
- **Strategy**: Prevent villain kills or info gathering

### 5. **Medic** (Protective)
- **Ability**: Give target one-time death immunity
- **Strategy**: Long-term protection

### 6. **Thief** (Disruptive)
- **Ability**: Steal random item from target
- **Strategy**: Resource control

### 7. **Messenger** (Support)
- **Ability**: Send anonymous message to all players
- **Strategy**: Share info safely

## Simplified Items (8 Total)

### Investigative (3)
- **Scanner**: See who target visited
- **Camera**: See who visited target  
- **Bug**: Hear if target was visited

### Protective (2)
- **Shield**: Self protection from elimination
- **Guard**: Protect another player

### Disruptive (3)
- **Jammer**: Block target's item use
- **Smoke**: Hide from all investigations
- **EMP**: Disable all items in target's inventory

## Simplified Phases

### Day Phase (5 minutes)
- Doors open, free movement
- 3 items spawn randomly
- Players can pick up 1 item max
- Talk and strategize

### Night Phase (2 minutes)
1. **Action Selection** (30 seconds)
   - Choose ONE action: Ability, Item, Visit, or Eliminate (villain only)
   - Choose target if needed

2. **Action Resolution** (90 seconds)
   - Actions resolve in order: Block → Protect → Investigate → Eliminate
   - Results shown to players

### Trial Phase (If death occurred)
1. **Investigation** (2 minutes)
   - Dead player's items become evidence
   - Search for clues

2. **Discussion** (2 minutes)
   - Free discussion
   - Share findings

3. **Vote** (1 minute)
   - Vote for suspected villain
   - Majority wins

## Simplified Action System

### Action Types (Priority Order)
1. **Block** - Prevents other actions
2. **Protect** - Prevents elimination  
3. **Investigate** - Gains information
4. **Eliminate** - Kills target (villain only)

### Action Rules
- One action per night
- Cannot target yourself (except self-protection items)
- Blocked actions fail with no effect
- Protected players survive elimination

## Implementation Simplifications

### Code Architecture
- Single controller file (~500 lines instead of 3500)
- Single character datum with ability type
- Simple item objects without complex interactions
- Basic UI with essential info only

### Removed Systems
- Trading system
- Contract system  
- Secondary actions
- Complex ability interactions
- Morning extensions
- Alibi phase
- Evidence scattering mechanics

### Simplified UI
- One main panel showing:
  - Current phase and timer
  - Player list with alive/dead status
  - Your character and items
  - Action selection dropdown
- Simple voting interface
- Basic results display

## Balance Considerations

### Character Distribution
- Always 1 villain (changes each round)
- 2-3 investigative characters
- 1-2 protective characters
- 2-3 disruptive characters
- 1 support character

### Item Spawning
- 3 items per day phase
- Weighted: 40% investigative, 30% disruptive, 30% protective
- Items disappear if not picked up

### Villain Advantages
- Knows who other players are
- Can lie about their character
- Can use abilities to seem innocent

## Quick Start Guide

### For New Players
1. Learn your character's ability
2. Pick up one item each day
3. Use ability OR item each night (not both)
4. Vote carefully - wrong votes cost points!

### Basic Strategy
- **As Innocent**: Share info, protect allies, find the villain
- **As Villain**: Act helpful, frame others, eliminate threats

## Technical Requirements

### Core Files Needed
1. `controller_simple.dm` - Main game logic
2. `characters_simple.dm` - 7 character definitions  
3. `items_simple.dm` - 8 item definitions
4. `ui_simple.dm` - Simplified interface
5. `map_simple.dmm` - Basic map with 10 rooms + main area

### Estimated Code Size
- ~1,500 lines total (vs 8,300 original)
- Focus on core mechanics only
- Minimal special cases

## Migration Path

### From Complex to Simple
1. Disable complex features via config
2. Limit character/item pools
3. Skip unnecessary phases
4. Use simplified UI mode

### Gradual Complexity
- Start with simple version
- Add features based on player feedback
- Keep core loop unchanged
