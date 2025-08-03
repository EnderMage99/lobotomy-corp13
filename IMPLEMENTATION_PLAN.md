# Villains Simplified - Implementation Plan (User-Testable Phases)

## Overview
This implementation plan is structured so that each phase delivers a playable, testable feature. Users can test and provide feedback after each phase, allowing for iterative improvement and early bug detection.

## Phase 1: Minimal Playable Game (Days 1-3)
**Goal**: Create the absolute minimum playable version where players can join, one becomes villain, and elimination works.

### Deliverables
- Basic lobby where players can join
- Simple character assignment (everyone is "Generic" character)
- Villain selection
- Basic elimination mechanic
- Win/loss detection

### Implementation
```dm
/datum/villains_simple_controller
    var/list/players = list()
    var/mob/villain
    var/game_active = FALSE
    
    proc/add_player(mob/player)
    proc/start_game()
    proc/select_villain()
    proc/eliminate_player(mob/target)
    proc/check_victory()
```

### User Testing
**What users can test:**
1. Join the game lobby
2. Start with 6+ players
3. One player randomly becomes villain
4. Villain can eliminate one player
4. Game ends when villain caught or too few players

**Test commands:**
- `/villains-join` - Join the game
- `/villains-start` - Start the game (admin)
- `/villains-eliminate [target]` - Eliminate player (villain only)

**Expected feedback:** Basic mechanics, join flow, elimination feel

---

## Phase 2: Day/Night Cycle (Days 4-6)
**Goal**: Add the core phase system with basic UI feedback.

### Deliverables
- Day phase (5 minutes) with movement
- Night phase (2 minutes) with action selection
- Basic UI showing current phase and timer
- Phase transitions with announcements

### Implementation
```dm
proc/change_phase(new_phase)
    current_phase = new_phase
    switch(new_phase)
        if(PHASE_DAY)
            announce("Day phase begins! 5 minutes to explore.")
            enable_movement()
        if(PHASE_NIGHT)
            announce("Night phase! Submit your action.")
            show_action_ui()
```

### User Testing
**What users can test:**
1. Experience day phase with free movement
2. Night phase locks players in rooms
3. Select basic actions (visit, eliminate)
4. Watch timer countdown
5. See phase transitions

**New test scenarios:**
- Phase transitions work smoothly
- Players can move during day
- Players are locked during night
- Timer displays correctly

**Expected feedback:** Phase timing, movement feel, UI clarity

---

## Phase 3: Character Abilities (Days 7-10)
**Goal**: Add the 7 unique characters with working abilities.

### Deliverables
- All 7 characters implemented
- Character selection during lobby
- Working abilities for each character
- Ability results shown to players

### Characters to Add
1. Detective - See who visited target
2. Guardian - Protect from elimination
3. Saboteur - Block actions
4. Spy - See inventory
5. Medic - Grant immunity
6. Thief - Steal items
7. Messenger - Send anonymous message

### User Testing
**What users can test:**
1. Select different characters in lobby
2. Use character abilities during night
3. See ability results
4. Experience ability interactions (block vs protect)

**Test matrix:**
| Character | Test Case | Expected Result |
|-----------|-----------|-----------------|
| Detective | Target active player | See who they visited |
| Guardian | Protect target from villain | Target survives |
| Saboteur | Block villain's kill | Kill fails |

**Expected feedback:** Ability balance, clarity of results, fun factor

---

## Phase 4: Items & Inventory (Days 11-14)
**Goal**: Add items that spawn and can be collected/used.

### Deliverables
- 8 items with effects
- Item spawning during day phase
- Inventory system (1 item max)
- Item usage during night

### Implementation Priority
1. Add inventory to player mob
2. Spawn 3 items each day
3. Pickup mechanics
4. Use item action in night phase

### User Testing
**What users can test:**
1. Find items during day phase
2. Pick up one item
3. See item in inventory
4. Use item during night
5. Experience item effects

**Specific test cases:**
- Shield item protects from elimination
- Scanner shows target's visits
- EMP disables target's item
- Items despawn if not collected

**Expected feedback:** Item spawn locations, pickup mechanics, effect clarity

---

## Phase 5: Investigation & Voting (Days 15-18)
**Goal**: Add the trial phase that occurs after eliminations.

### Deliverables
- Investigation phase (2 min) after death
- Dead player's items become evidence
- Discussion phase (2 min)
- Voting phase (1 min)
- Vote results and reveal

### Testing Flow
```
Day → Night → [Someone dies] → Investigation → Discussion → Vote → Results
```

### User Testing
**What users can test:**
1. Investigate after someone dies
2. Find evidence items
3. Discuss findings
4. Vote for suspected villain
5. See voting results

**Test scenarios:**
- Correct vote (villain identified)
- Incorrect vote (innocent blamed)
- Tie vote handling
- No vote handling

**Expected feedback:** Investigation time, voting UI, reveal drama

---

## Phase 6: Victory Points & Rounds (Days 19-21)
**Goal**: Add the multi-round system with victory points.

### Deliverables
- Victory point tracking (+1/-1)
- Multiple rounds with new villains
- Game end when <5 players
- Final winner calculation
- Round transition flow

### Implementation
```dm
proc/process_vote_results()
    if(voted_player == villain)
        // Correct! +1 point to voters
        announce("The villain was caught!")
    else
        // Wrong! -1 point to voters
        announce("An innocent was blamed!")
    
    start_new_round()
```

### User Testing
**What users can test:**
1. Play multiple rounds
2. See victory points change
3. Experience different villains
4. Reach game end condition
5. See final winners

**Full game test:**
- 7 players start
- Round 1: Vote correctly (+1 point)
- Round 2: Vote incorrectly (-1 point)
- Round 3: Game ends (4 players left)
- Winners announced (those with 1+ points)

**Expected feedback:** Point system clarity, round length, endgame satisfaction

---

## Phase 7: Polish & Balance (Days 22-28)
**Goal**: Improve UI, balance abilities/items, and fix remaining issues.

### Deliverables
- Polished UI with character portraits
- Sound effects for key events
- Balance adjustments based on testing
- Bug fixes from all previous phases
- Admin tools for testing

### Polish Areas
1. **Visual**: Phase indicators, timer styling, result animations
2. **Audio**: Phase changes, eliminations, voting
3. **Balance**: Ability cooldowns, item spawn rates
4. **QoL**: Hotkeys, better target selection, action confirmation

### User Testing
**Final test checklist:**
- [ ] Complete game with 6 players
- [ ] Complete game with 10 players
- [ ] All abilities used successfully
- [ ] All items function correctly
- [ ] No major bugs in 10 consecutive games
- [ ] Average game time 20-30 minutes

**Expected feedback:** Final polish needs, remaining bugs, overall fun

---

## Testing Protocol for Each Phase

### 1. Developer Testing (1 hour)
- Basic functionality works
- No critical errors
- Commands respond correctly

### 2. Internal Testing (2 hours)
- Small group (3-4 people)
- Run through all features
- Document bugs

### 3. Community Testing (4 hours)
- Open test server
- 6-10 players
- Collect feedback form

### 4. Iteration (remaining time)
- Fix critical bugs
- Adjust based on feedback
- Prepare next phase

## Feedback Collection Template

After each phase, collect:
1. **What worked well?**
2. **What was confusing?**
3. **What was broken?**
4. **What was missing?**
5. **Fun rating (1-10)**

## Success Metrics per Phase

### Phase 1 Success
- 6 players can join and start
- Villain can eliminate
- Game ends properly

### Phase 2 Success  
- Phases transition smoothly
- Timer is accurate
- Players understand current phase

### Phase 3 Success
- All abilities work
- Results are clear
- No ability breaks the game

### Phase 4 Success
- Items spawn correctly
- Pickup works intuitively
- Item effects are noticeable

### Phase 5 Success
- Investigation is engaging
- Voting is smooth
- Results create drama

### Phase 6 Success
- Points track correctly
- Rounds flow well
- Winners are satisfying

### Phase 7 Success
- Game feels polished
- No major bugs remain
- Players want to play again

## Development Tools

### Debug Commands (Add in Phase 1)
```dm
/client/proc/villains_debug_panel()
    // Force phase change
    // Give items
    // Set villain
    // Modify points
```

### Testing Shortcuts
- `/villains-phase [phase]` - Force phase change
- `/villains-give-item [item]` - Give item to self
- `/villains-set-villain [player]` - Force villain
- `/villains-end-game` - Force game end

## Risk Management

### If a phase fails testing:
1. **Minor issues**: Fix and continue
2. **Major issues**: Extend phase by 1-2 days
3. **Blocking issues**: Simplify feature and proceed

### Minimum Viable Features per Phase:
- **Phase 1**: Can eliminate manually (no UI needed)
- **Phase 2**: Phases change (timing can be adjusted)
- **Phase 3**: 3 core abilities work (can add others later)
- **Phase 4**: 3 basic items work (can add more later)
- **Phase 5**: Basic voting (can polish UI later)
- **Phase 6**: Points track (can improve display later)

## Timeline Summary

| Week | Phases | Testable Features |
|------|--------|-------------------|
| 1 | 1-2 | Basic game + Phase system |
| 2 | 3-4 | Characters + Items |
| 3 | 5-6 | Voting + Victory points |
| 4 | 7 | Polish + Final testing |

## Conclusion

This phased approach ensures users can test meaningful features after each phase, providing valuable feedback throughout development. Each phase builds on the previous one, creating a steady progression toward the complete game while maintaining playability at every step.
