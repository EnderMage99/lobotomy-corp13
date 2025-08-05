# Tinkerer RTS Commander Enhancement Plan

## Overview
This document outlines a phased approach to transform the Tinkerer unit into a true RTS commander, similar to playing StarCraft, Command & Conquer, or Age of Empires. Each phase is designed to be implemented and tested independently before moving to the next.

## Core Design Principles
- **Resource Management**: Players must gather and manage resources
- **Strategic Decision Making**: Balance between economy, production, and combat
- **Unit Micromanagement**: Direct control over multiple units with formations
- **Base Building**: Construct and defend strategic positions
- **Tech Progression**: Unlock new units and upgrades over time

---

## Phase 1: Core Resource System
**Goal**: Implement basic resource gathering and spending mechanics

### Features
1. **Metal Resource**
   - Add metal counter to tinkerer (separate from charge)
   - Metal used for unit production
   - Starting metal: 100

2. **Resource Nodes**
   - Create destructible metal deposits on map
   - Each deposit contains 500-1000 metal
   - Visual indication of remaining resources

3. **Harvester Units**
   - New unit type: Harvester (2 capacity cost)
   - Can extract 10 metal per trip
   - Auto-returns to nearest factory when full
   - 2 second harvest time

4. **Resource Costs**
   - Scout: 25 metal
   - Harvester: 50 metal
   - Engineer: 75 metal
   - Drone: 100 metal
   - Assassin: 150 metal
   - Defender: 125 metal
   - Demolisher: 200 metal

### Implementation
```dm
// Add to tinkerer
var/metal = 100
var/metal_income_rate = 0

// New harvester unit
/mob/living/simple_animal/hostile/clan/harvester
    name = "Clan Harvester"
    desc = "Resource gathering unit"
    var/carrying_metal = 0
    var/max_carry = 10
    var/harvest_time = 2 SECONDS
```

### Testing Checklist
- [ ] Tinkerer displays metal count
- [ ] Harvesters can gather from deposits
- [ ] Units cost metal to produce
- [ ] Cannot produce without sufficient metal
- [ ] Harvesters auto-return when full

---

## Phase 2: Enhanced Unit Control
**Goal**: Improve unit selection and control for RTS-style gameplay

### Features
1. **Increased Selection Cap**
   - Increase from 5 to 15 units max selection
   - Visual feedback for selection limit

2. **Control Groups**
   - Save selection to groups 1-9
   - Quick select saved groups
   - Visual indicator for grouped units

3. **Double-Click Selection**
   - Double-click unit to select all of same type on screen
   - Range limit to visible area

4. **Formation Movement**
   - Units maintain relative positions when moving
   - Box formation by default
   - Line formation option

5. **Rally Points**
   - Set rally points for factories
   - New units auto-move to rally point
   - Visual indicator for rally location

### Implementation
```dm
// Add to tinkerer
var/max_selected_units = 15
var/list/control_groups = list()
var/list/factory_rally_points = list()

/mob/living/simple_animal/hostile/clan/tinkerer/proc/SaveControlGroup(group_num)
    if(group_num < 1 || group_num > 9)
        return
    control_groups["[group_num]"] = selected_units.Copy()
```

### Testing Checklist
- [ ] Can select up to 15 units
- [ ] Control groups save and load correctly
- [ ] Double-click selects all units of type
- [ ] Units move in formation
- [ ] Rally points work for new units

---

## Phase 3: Advanced Buildings
**Goal**: Expand base building options beyond factories

### Features
1. **Defensive Turret**
   - 300 metal cost
   - Auto-attacks enemies in range
   - 500 HP, 10-15 damage
   - Requires power connection

2. **Resource Depot**
   - 200 metal cost
   - Increases metal storage cap by 500
   - Harvesters can deposit here

3. **Power Generator**
   - 150 metal cost
   - Powers buildings in radius
   - Can chain power through pylons

4. **Build Preview System**
   - Ghost preview before placement
   - Red/green validity indicator
   - Snap to grid option

### Implementation
```dm
/obj/structure/clan_turret
    name = "Clan Defense Turret"
    var/powered = FALSE
    var/damage = 12
    var/fire_delay = 2 SECONDS

/obj/structure/clan_depot
    name = "Resource Depot"
    var/stored_metal = 0
    var/max_storage = 500
```

### Testing Checklist
- [ ] All buildings can be placed
- [ ] Turrets attack enemies automatically
- [ ] Power system connects buildings
- [ ] Resource depots accept deposits
- [ ] Preview system shows valid placement

---

## Phase 4: Tech Tree & Upgrades
**Goal**: Add progression and strategic choices

### Features
1. **Tech Lab Building**
   - 250 metal cost
   - Researches upgrades
   - One research at a time

2. **Unit Upgrades**
   - Damage Boost I/II/III (+10/20/30%)
   - Armor Plating I/II/III (+10/20/30% HP)
   - Speed Boost I/II (+15/30% speed)
   - Each costs 100/200/300 metal

3. **Building Upgrades**
   - Fortified Structures (+50% HP)
   - Improved Turrets (+25% fire rate)
   - Efficient Harvesting (+25% gather rate)

4. **Advanced Units** (Require Tech Lab)
   - Siege Unit: Long range, high damage
   - Medic: Heals other units
   - Cloaker: Invisible when still

5. **Research Queue**
   - Visual progress bar
   - Queue up to 5 researches
   - Cancel and refund option

### Implementation
```dm
/obj/structure/clan_techlab
    var/researching = null
    var/research_progress = 0
    var/list/research_queue = list()
    var/list/completed_research = list()
```

### Testing Checklist
- [ ] Tech lab can be built
- [ ] Upgrades apply correctly to units
- [ ] Research queue works
- [ ] Advanced units require tech lab
- [ ] Upgrades persist through unit production

---

## Phase 5: Vision & Intelligence
**Goal**: Add fog of war and scouting mechanics

### Features
1. **Unit Vision Radius**
   - Each unit type has different vision
   - Scout: 10 tiles
   - Normal: 7 tiles
   - Harvester: 5 tiles

2. **Fog of War**
   - Unexplored areas are black
   - Previously seen areas are grey
   - Current vision is clear

3. **Strategic View Mode**
   - Toggle to overhead view
   - See entire explored map
   - Issue commands from this view

4. **Intel Abilities**
   - Scan: Reveal area temporarily (50 metal)
   - Spy Satellite: Permanent vision on area (200 metal)
   - Motion Sensor: Detects movement in fog

### Implementation
```dm
/mob/living/simple_animal/hostile/clan
    var/vision_radius = 7
    var/list/explored_turfs = list()

/datum/fog_of_war
    var/list/visible_turfs = list()
    var/list/explored_turfs = list()
```

### Testing Checklist
- [ ] Units have limited vision
- [ ] Fog of war obscures unseen areas
- [ ] Strategic view mode works
- [ ] Intel abilities reveal areas
- [ ] Vision updates in real-time

---

## Phase 6: Advanced Combat
**Goal**: Add depth to combat mechanics

### Features
1. **Unit Stances**
   - Aggressive: Attack anything in range
   - Defensive: Only attack when attacked
   - Hold Position: Don't move, attack in range
   - No Attack: Never attack

2. **Focus Fire System**
   - Target priority settings
   - Attack-move with smart targeting
   - Shift-queue attack orders

3. **Special Abilities**
   - EMP: Disable mechanical units
   - Smoke Screen: Block vision
   - Overcharge: Temporary damage boost
   - Each costs charge to use

4. **Unit Veterancy**
   - Units gain XP from kills
   - 3 veteran levels
   - Each level: +10% stats
   - Visual indicator (stars)

5. **Damage Types**
   - Different armor vs damage types
   - Counter-unit relationships
   - Visible damage numbers option

### Implementation
```dm
/mob/living/simple_animal/hostile/clan
    var/stance = "aggressive"
    var/experience = 0
    var/veteran_level = 0
    var/list/ability_cooldowns = list()
```

### Testing Checklist
- [ ] Stances change unit behavior
- [ ] Focus fire works correctly
- [ ] Special abilities have proper effects
- [ ] Veterans gain bonuses
- [ ] Counter units work as designed

---

## Phase 7: Polish & UI
**Goal**: Improve player experience and feedback

### Features
1. **Production Queue Display**
   - Show all factories' queues
   - Time remaining on production
   - Cancel production option

2. **Resource Income Display**
   - Metal per minute calculation
   - Harvester efficiency stats
   - Resource depletion warnings

3. **Hotkey System**
   - Q-W-E-R for abilities
   - A for attack-move
   - S for stop
   - H for hold position
   - Customizable bindings

4. **Audio Feedback**
   - Unit acknowledgment sounds
   - Production complete alerts
   - Under attack warnings
   - Low resource alerts

5. **Visual Polish**
   - Health bars on all units
   - Production progress bars
   - Range indicators
   - Path preview lines

### Implementation
```dm
/datum/tinkerer_ui
    var/show_production_queue = TRUE
    var/show_resource_stats = TRUE
    var/list/custom_hotkeys = list()
```

### Testing Checklist
- [ ] All UI elements display correctly
- [ ] Hotkeys respond properly
- [ ] Audio cues play at right times
- [ ] Visual feedback is clear
- [ ] Performance remains smooth

---

## Performance Considerations

### Optimization Targets
- Support 50+ units without lag
- Efficient pathfinding for groups
- Minimal UI update frequency
- Batch similar operations

### Profiling Points
- Unit AI processing time
- Vision calculation cost
- UI render time
- Network sync load

---

## Balance Guidelines

### Economy Balance
- Early game: 1-2 harvesters
- Mid game: 4-5 harvesters
- Late game: 6-8 harvesters
- Metal income should support constant production

### Combat Balance
- No single unit type dominates
- Combined arms encouraged
- Defender's advantage (turrets strong)
- Harassment viable but not overwhelming

### Progression Balance
- 5-10 minutes to first advanced unit
- 15-20 minutes to fully upgraded army
- Upgrades meaningful but not mandatory
- Multiple viable strategies

---

## Future Expansion Ideas

1. **Multiple Commanders**
   - Different tinkerer variants
   - Unique units per commander
   - Special commander abilities

2. **Map Objectives**
   - Capture points for bonuses
   - Neutral structures to claim
   - Timed events

3. **AI Improvements**
   - Smarter unit pathfinding
   - Formation preservation
   - Tactical retreats

4. **Multiplayer Considerations**
   - Ally resource sharing
   - Coordinated attacks
   - Team upgrades
