/mob/living/simple_animal/hostile/humanoid/fixer/priest
	name = "Priest Fixer"
	desc = "Too young to be called a man, but too mature to be called a boy. He had white hair and white skin. His eyes are calm and he had stubborn lips."
	icon_state = "priest_fixer"
	icon_living = "priest_fixer"
	icon_dead = "priest_fixer"
	maxHealth = 2500
	health = 2500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)

	melee_damage_lower = 12
	melee_damage_upper = 18
	rapid_melee = 1 // Slow attack speed


	var/stagger = 0
	var/max_stagger = 1000 // Adjust this value as needed
	var/list/lifelinked_creatures = list()
	var/max_lifelinks = 4
	var/lifelink_range = 6
	var/stunned = FALSE
	var/list/current_beams



	// Override the parent's can_act variable
	can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/fixer/priest/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/update_lifelinks), 10 SECONDS, TIMER_LOOP)

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/update_lifelinks()
	if(!stunned && can_act)
		check_for_lifelink_targets()
		follow_lowest_hp_target()

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/check_for_lifelink_targets()
	var/list/potential_targets = list()
	for(var/mob/living/L in view(lifelink_range, src))
		if(L != src && !L.has_status_effect(/datum/status_effect/lifelink))
			potential_targets += L

	while(lifelinked_creatures.len < max_lifelinks && potential_targets.len > 0)
		var/mob/living/target = pick(potential_targets)
		if(!(target in lifelinked_creatures))
			create_lifelink(target)
		potential_targets -= target

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/create_lifelink(mob/living/target)
	if(lifelinked_creatures.len >= max_lifelinks)
		remove_lifelink(lifelinked_creatures[1])
	lifelinked_creatures += target
	var/datum/status_effect/lifelink/link = target.apply_status_effect(/datum/status_effect/lifelink)
	link.linker = src
	create_beam(target)

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/remove_lifelink(mob/living/target)
	lifelinked_creatures -= target
	target.remove_status_effect(/datum/status_effect/lifelink)
	remove_beam(target)

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/create_beam(mob/living/target)
	var/datum/beam/B = Beam(target, icon_state="medbeam", time=INFINITY, maxdistance=lifelink_range, beam_type=/obj/effect/ebeam/medical)
	current_beams[target] = B

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/remove_beam(mob/living/target)
	var/datum/beam/B = current_beams[target]
	if(B)
		B.End()
		current_beams -= target

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/follow_lowest_hp_target()
	if(lifelinked_creatures.len > 0)
		var/mob/living/lowest_hp_target = lifelinked_creatures[1]
		for(var/mob/living/L in lifelinked_creatures)
			if(L.health < lowest_hp_target.health)
				lowest_hp_target = L

		// Use the existing AI to move towards the target
		target = lowest_hp_target



/mob/living/simple_animal/hostile/humanoid/fixer/priest/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(amount > 0)
		stagger += amount
		check_stagger()



/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/check_stagger()
	if(stagger >= max_stagger)
		stunned = TRUE
		can_act = FALSE
		for(var/mob/M in lifelinked_creatures)
			remove_lifelink(M)
		addtimer(CALLBACK(src, .proc/unstun), 5 SECONDS)

/mob/living/simple_animal/hostile/humanoid/fixer/priest/proc/unstun()
	stunned = FALSE
	can_act = TRUE
	stagger = 0

/mob/living/simple_animal/hostile/humanoid/fixer/priest/Life()
	. = ..()
	if(.) // If the mob isn't dead
		stagger = max(0, stagger - 5) // Reduce stagger over time

/mob/living/simple_animal/hostile/humanoid/fixer/priest/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	return ..()



/datum/status_effect/lifelink
	id = "lifelink"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/lifelink
	var/mob/living/simple_animal/hostile/humanoid/fixer/priest/linker

/atom/movable/screen/alert/status_effect/lifelink
	name = "Life Link"
	desc = "Your wounds are being transferred to a Priest Fixer."
	icon_state = "lifelink"

/datum/status_effect/lifelink/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, .proc/transfer_damage)
	return TRUE

/datum/status_effect/lifelink/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/datum/status_effect/lifelink/proc/transfer_damage(mob/living/source, damage, damagetype)
	SIGNAL_HANDLER
	if(linker && damage > 0)
		linker.adjustHealth(damage, updating_health = TRUE, forced = FALSE)
		return COMPONENT_MOB_DENY_DAMAGE
	return NONE
