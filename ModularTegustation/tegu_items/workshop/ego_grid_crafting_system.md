# Weaponry Material Grid Crafting System

## System Overview

The Weaponry Grid Crafting System is a unique crafting mechanic where players navigate a "focus point" through a coordinate grid using weaponry materials to reach weapon coordinates and craft city weapons. The system creates a strategic resource management challenge where material properties determine movement patterns.

## Core Mechanics

### 1. The Grid
- **Infinite 2D coordinate system** with origin at (0, 0)
- **Focus Point**: Current position marker that starts at (0, 0)
- **Weapon Coordinates**: Fixed positions on the grid where weapons can be crafted
- **Influence Radius**: Each weapon has a circular area where it can be crafted

### 2. Movement System

Materials move the focus point based on their properties:

#### Material Properties
- **Rarity** (0-4+): Determines movement distance
  - 0 (Crude): 1-2 units
  - 1 (Common): 3-5 units
  - 2 (Refined): 6-10 units
  - 3 (Exceptional): 11-20 units
  - 4+ (Legendary): 21-40 units

- **Damage Type**: Determines movement direction/pattern
  - RED: Cardinal directions (N/S/E/W)
  - WHITE: Diagonal directions (NE/NW/SE/SW)
  - BLACK: Diagonal/Cardinal movement (N/S/E/W/NE/NW/SE/SW)
  - PALE: Teleport to location within range (player choice)

- **Density**: Modifies movement behavior
  - Lightweight: +25% distance
  - Normal: Standard distance
  - Heavy: -50% distance, When landing in multiple weapon radius, gain the ability to pick a specific weapon.

### 3. Weapon Placement Algorithm

```
Algorithm adjusted based on weapon density per rarity:
- More weapons in a rarity = smaller radius to prevent overlap
- Distance ranges expanded for crowded rarities to ensure 2+ unit spacing

Rarity 0 (46 weapons): Distance 5-25, Radius 10
Rarity 1 (19 weapons): Distance 20-40, Radius 12  
Rarity 2 (65 weapons): Distance 35-65, Radius 8
Rarity 3 (12 weapons): Distance 55-85, Radius 8
Rarity 4 (3 weapons):  Distance 75-105, Radius 6

Note: The high weapon count in Rarity 2 requires the largest distance 
range to prevent coordinate clustering.
```

### 4. Crafting Process

1. Player starts at (0, 0)
2. Uses materials to move focus point
3. After using at least 1 material, check if within any weapon radius
4. If within radius:
   - Single weapon: Craft that weapon
   - Multiple weapons: Random selection
5. Focus point resets to (0, 0)

## Visual Example

```
        [R3:8]
          *
    
    [R2:12]         [R2:12]
       *               *
    
            F(0,0)
    
    [R1:16]         [R1:16]
       *               *
    
        [R0:20]
          *

Legend:
F = Focus Point
* = Weapon Coordinate
[Rn:r] = Rarity n weapon with radius r
```

## Weaponry Disassembler

The weaponry disassembler converts existing weapons into weapon shards used for grid navigation.

### Operation
1. **Load Weapons**: Insert weaponry into the disassembler (accepts `/obj/item/ego_weapon`)
2. **Activate**: Use harm intent on the machine to begin processing
3. **Processing**: Machine takes 5 seconds to disassemble all loaded weapons
4. **Output**: Each weapon produces 4-7 weapon shards

### Shard Property Generation

Each weapon shard inherits properties from the disassembled weapon:

#### Rarity Calculation
```
Average Requirement = Sum of all attribute requirements / Number of requirements
Shard Rarity = Average Requirement / 30
```
- Weapons with no requirements → Rarity 0 (Crude)
- Average 30 requirements → Rarity 1 (Common)
- Average 60 requirements → Rarity 2 (Refined)
- Average 90 requirements → Rarity 3 (Exceptional)
- Average 120+ requirements → Rarity 4+ (Legendary)

#### Density Mapping
Based on weapon attack speed:
- Attack Speed < 0.7 → "lightweight" shard
- Attack Speed 0.7-1.3 → "normal" shard
- Attack Speed > 1.3 → "heavy" shard

#### Damage Type
Directly inherited from weapon's `damtype`:
- RED_DAMAGE → Red shards (Cardinal movement)
- WHITE_DAMAGE → White shards (Diagonal movement)
- BLACK_DAMAGE → Black shards (8-directional movement)
- PALE_DAMAGE → Pale shards (Teleport movement)

### Usage Example
1. Load a "kurokumo blade" (Avg Req: 80, RED damage, Speed: 1.2)
2. Activate disassembler
3. Receive 4-7 shards with:
   - Rarity 2 (80/30 = 2.67 → 2)
   - Normal density (speed 1.2)
   - Red damage type

These shards can then be used to move 6-10 units in cardinal directions on the crafting grid.

## Implementation Suggestions

### Data Structures

```dm
/datum/weaponry_grid_system
    var/list/weapon_coordinates = list() // list of /datum/weapon_coordinate
    var/focus_x = 0
    var/focus_y = 0
    var/list/materials_used = list()
    
/datum/weapon_coordinate
    var/x
    var/y
    var/radius
    var/weapon_path
    var/weapon_name
    var/rarity
```

### Movement Calculation

```dm
/datum/weaponry_grid_system/proc/ApplyMaterial(obj/item/weapon_shard/M)
    var/base_distance = GetBaseDistance(M.rarity)
    
    // Apply density modifier
    switch(M.material_density)
        if("lightweight")
            base_distance *= 1.25  // +25% distance
        if("heavy")
            base_distance *= 0.5   // -50% distance
            // Heavy materials also allow weapon selection when landing in multiple radii
    
    // Apply movement based on damage type
    switch(M.damage_type)
        if(RED_DAMAGE)
            // Cardinal movement (N/S/E/W)
        if(WHITE_DAMAGE)
            // Diagonal movement (NE/NW/SE/SW)
        if(BLACK_DAMAGE)
            // Diagonal/Cardinal movement (N/S/E/W/NE/NW/SE/SW)
        if(PALE_DAMAGE)
            // Teleport to location within range (player choice)
```

## Expansion Ideas

### 1. Material Combinations
- Using multiple materials in sequence creates combo effects
- Example: RED + WHITE = Spiral movement pattern
- BLACK + PALE = Controlled teleport to nearest weapon

### 2. Grid Modifiers
- **Void Zones**: Areas that can't be crossed normally
- **Boost Zones**: Double movement in certain areas
- **Faction Territories**: Weapons easier to craft in their faction's zone

### 3. Advanced Mechanics
- **Momentum System**: Consecutive same-type materials increase distance
- **Precision Mode**: Sacrifice distance for exact positioning
- **Material Recycling**: Failed attempts return some materials

### 4. Visual Feedback
- **Trail System**: Show path taken by focus point
- **Heat Map**: Display frequently visited coordinates
- **Weapon Preview**: Show potential weapons when nearby

### 5. Progression Systems
- **Grid Mastery**: Unlock ability to see weapon coordinates
- **Material Efficiency**: Reduce material cost over time
- **Custom Recipes**: Save successful paths for quick crafting

### 6. Strategic Elements
- **Resource Chains**: Some weapons require visiting multiple coordinates
- **Temporary Weapons**: Some coordinates shift position periodically
- **Exclusive Zones**: Rare weapons only appear after specific material sequences

## Balance Considerations

1. **Material Scarcity**: Make high-rarity materials valuable but not mandatory
2. **Risk/Reward**: Longer paths risk missing targets but reach better weapons
3. **Learning Curve**: Start with visible nearby weapons, hide distant ones
4. **Failure Recovery**: Partial refunds or consolation prizes for failed attempts

## UI/UX Recommendations

1. **Grid Visualization**: 
   - Minimap showing local area
   - Zoom in/out functionality
   - Coordinate display

2. **Material Preview**:
   - Show potential movement before confirming
   - Display compatible weapons in range

3. **History Tracking**:
   - Previous successful paths
   - Material usage statistics

## Technical Notes

- Store weapon coordinates in a datum for easy save/load
- Use spatial hashing for efficient radius checks
- Consider chunk-based loading for very large grids
- Implement undo system for misclicks

## Conclusion

This system creates a unique crafting experience that:
- Rewards strategic planning
- Makes all material types valuable
- Scales naturally with weapon rarity
- Provides clear progression goals
- Offers high replayability through randomization

The grid system transforms simple material collection into an engaging puzzle-like experience where players must carefully manage resources to reach their desired weapons.
