
// --------HE---------
//Rhythm
/obj/item/ego_weapon/ranged/branch12/rhythm
	name = "rhythm"
	desc = "Never stop moving. The beat goes on."
	special = "This weapon gains increased damage and fire rate based on how much you've moved recently. \
	Standing still will reset your momentum bonus. \
	Every shot inflicts 1 Mental Decay, increased by your momentum level."
	icon_state = "rhythm"
	inhand_icon_state = "rhythm"
	force = 15
	projectile_path = /obj/projectile/ego_bullet/branch12/rhythm
	fire_delay = 6
	spread = 5
	shotsleft = 12
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	var/momentum_level = 0
	var/max_momentum = 5
	var/last_turf
	var/movement_counter = 0
	var/check_time = 0

/obj/item/ego_weapon/ranged/branch12/rhythm/equipped(mob/user, slot)
	. = ..() 
	if(ishuman(user))
		START_PROCESSING(SSobj, src)
		last_turf = get_turf(user)

/obj/item/ego_weapon/ranged/branch12/rhythm/dropped(mob/user)
	. = ..() 
	STOP_PROCESSING(SSobj, src)
	momentum_level = 0
	movement_counter = 0

/obj/item/ego_weapon/ranged/branch12/rhythm/process()
	if(!isliving(loc))
		return
	var/mob/living/user = loc
	var/current_turf = get_turf(user)
	
	if(current_turf != last_turf)
		movement_counter++
		last_turf = current_turf
	
	if(world.time >= check_time)
		check_time = world.time + 2 SECONDS
		if(movement_counter >= 4)
			if(momentum_level < max_momentum)
				momentum_level++
				to_chat(user, span_notice("Your momentum increases! [momentum_level]/[max_momentum]"))
				fire_delay = max(3, initial(fire_delay) - momentum_level)
		else if(movement_counter < 2)
			if(momentum_level > 0)
				momentum_level = 0
				fire_delay = initial(fire_delay)
				to_chat(user, span_warning("You lose your rhythm!"))
		movement_counter = 0

/obj/projectile/ego_bullet/branch12/rhythm
	name = "rhythmic shot"
	damage = 25
	damage_type = BLACK_DAMAGE
	var/decay_inflict = 1

/obj/projectile/ego_bullet/branch12/rhythm/on_hit(atom/target, blocked = FALSE)
	. = ..() 
	if(!isliving(target) || !isliving(firer))
		return
	
	var/obj/item/ego_weapon/ranged/branch12/rhythm/gun = fired_from
	if(istype(gun))
		damage = initial(damage) + (gun.momentum_level * 5)
		decay_inflict = 1 + gun.momentum_level
	
	var/mob/living/L = target
	L.apply_lc_mental_decay(decay_inflict)

//Perfectionist
/obj/item/ego_weapon/branch12/perfectionist
	name = "perfectionist"
	desc = "I couldn�t bear it, they silently judged, accusing every step I took."
	special = "Upon hitting living target, You have a chance to critically hit the target dealing quadruple damage. However, if you don't hit you take some damage. <br>\
	This weapon also inflicts 2 Mental Decay on hit, and if the target has Mental Detonation, shatter it, inflict double the Mental Decay and guarantee a critical hit. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "perfectionist"
	force = 30
	reach = 3
	stuntime = 8
	attack_speed = 0.7
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("whips", "lashes", "tears")
	attack_verb_simple = list("whip", "lash", "tear")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/crit_chance = 5
	var/default_crit_chance = 5
	var/crit_chance_raise = 5
	var/inflicted_decay = 2

/obj/item/ego_weapon/branch12/perfectionist/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_mental_decay(inflicted_decay)
		var/datum/status_effect/mental_detonate/D = target.has_status_effect(/datum/status_effect/mental_detonate)
		if(prob(crit_chance) || D)
			if(D)
				D.shatter()
				target.apply_lc_mental_decay(inflicted_decay)
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust / 100
			var/extra_damage = force
			extra_damage *= justicemod
			target.deal_damage(extra_damage*3, damtype)
			playsound(target, 'sound/abnormalities/spiral_contempt/spiral_hit.ogg', 50, TRUE, 4)
			to_chat(user, span_nicegreen("FOR THEIR PERFORMANCE, I SHALL ACT!"))
			crit_chance = default_crit_chance
		else
			crit_chance += crit_chance_raise
			user.deal_damage(force*0.25, damtype)
			to_chat(user, span_boldwarning("They are watching... Judging..."))

/obj/item/ego_weapon/branch12/nightmares
	name = "childhood nightmares"
	desc = "A small side satchel with throwable items inside, the contents inside vary in appearance between people."
	special = "This weapon has a ranged attack, which throws out small plushies which inflict 2 Mental Decay on hit, this weapon also inflicts 2 Mental Decay on hit. You gain plushies to throw by attacking targets. <br><br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "nightmares"
	inhand_icon_state = "nightmares"
	force = 25
	damtype = WHITE_DAMAGE
	hitsound = 'sound/abnormalities/happyteddy/teddy_guard.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/inflicted_decay = 2
	var/ranged_cooldown
	var/ranged_cooldown_time = 1 SECONDS
	var/ranged_range = 7
	var/max_stored_pals = 3
	var/stored_pals = 3

/obj/item/ego_weapon/branch12/nightmares/examine(mob/user)
	. = ..()
	. += span_notice("This satchel is currently holding [stored_pals] out of [max_stored_pals] friends!")

/obj/item/ego_weapon/branch12/nightmares/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		target.apply_lc_mental_decay(inflicted_decay)
	if(stored_pals < max_stored_pals)
		if(prob(60))
			to_chat(user, span_nicegreen("Hey! You found another friend."))
			stored_pals++

/obj/item/ego_weapon/branch12/nightmares/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time || !CanUseEgo(user) || (stored_pals < 1))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf) || (get_dist(user, target_turf) < 3) || !(target_turf in view(ranged_range, user)))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	stored_pals--
	playsound(src, 'sound/weapons/throwhard.ogg', 25, TRUE)
	var/mob/living/simple_animal/hostile/nightmare_toy/thrown_object = new(get_turf(user))
	thrown_object.throw_at(target_turf, 10, 3, user, spin = TRUE)

/mob/living/simple_animal/hostile/nightmare_toy
	name = "Forgotten Plush"
	desc = "Have I seen them before?"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "plushie_slime"
	icon_living = "plushie_slime"
	gender = NEUTER
	density = FALSE
	mob_biotypes = MOB_ROBOTIC
	faction = list("neutral")
	health = 100
	maxHealth = 100
	healable = FALSE
	melee_damage_lower = 4
	melee_damage_upper = 6
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/abnormalities/happyteddy/teddy_guard.ogg'
	var/list/plushies = list("debug", "plushie_snake", "plushie_lizard", "plushie_spacelizard", "plushie_slime", "plushie_nuke", "plushie_pman", "plushie_awake", "plushie_h", "goat", "fumo_cirno")
	var/inflicted_decay = 2

/mob/living/simple_animal/hostile/nightmare_toy/Initialize()
	shuffle_inplace(plushies)
	icon_state = plushies[1]
	icon_living = plushies[1]
	QDEL_IN(src, (10 SECONDS))
	. = ..()
	faction = list("neutral")
	resize = 0.75

/mob/living/simple_animal/hostile/nightmare_toy/AttackingTarget(atom/attacked_target)
	. = ..()
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		L.apply_lc_mental_decay(inflicted_decay)


/obj/item/ego_weapon/branch12/egoification
	name = "Egoification!"
	desc = "Egoification!"
	icon_state = "egoification"
	force = 45
	reach = 2		//Has 2 Square Reach.
	stuntime = 7	//This is MEANT to be a throwing weapon, so we're gonna make it stun for longer
	throwforce = 60		//It costs like 50 PE I guess you can go nuts
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/branch12/egoification/get_clamped_volume()
	return 25

//Solar Day
/obj/item/ego_weapon/branch12/solar_day
	name = "solar day"
	desc = "The burning light of day incarnate."
	special = "This weapon burns enemies and has a chance to blind them on hit. \
	Every third hit creates a solar flare that damages and blinds all enemies in a small area. \
	Using this weapon in hand creates a blinding flash that stuns nearby enemies."
	icon_state = "solar_day"
	force = 32
	damtype = WHITE_DAMAGE
	attack_speed = 1.1
	reach = 2
	attack_verb_continuous = list("burns", "scorches", "sears")
	attack_verb_simple = list("burn", "scorch", "sear")
	hitsound = 'sound/items/welder.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/hit_counter = 0
	var/flare_damage = 20
	var/blind_chance = 30
	var/flash_cooldown = 0
	var/flash_cooldown_time = 20 SECONDS

/obj/item/ego_weapon/branch12/solar_day/attack(mob/living/target, mob/living/user)
	. = ..() 
	if(!isliving(target))
		return
	
	// Burn damage
	target.deal_damage(5, RED_DAMAGE)
	
	// Chance to disorient
	if(prob(blind_chance) && isliving(target))
		var/mob/living/L = target
		L.add_movespeed_modifier(/datum/movespeed_modifier/solar_dazzle)
		addtimer(CALLBACK(src, PROC_REF(RemoveDazzle), L), 3 SECONDS)
		to_chat(L, span_userdanger("The burning light dazzles you!"))
	
	// Solar flare every third hit
	hit_counter++
	if(hit_counter >= 3)
		hit_counter = 0
		solar_flare(target, user)

/obj/item/ego_weapon/branch12/solar_day/proc/solar_flare(atom/center, mob/living/user)
	playsound(center, 'sound/magic/lightningshock.ogg', 50, TRUE)
	new /obj/effect/temp_visual/emp/pulse(get_turf(center))
	
	for(var/mob/living/L in range(2, center))
		if(L == user)
			continue
		L.deal_damage(flare_damage, WHITE_DAMAGE)
		L.deal_damage(10, RED_DAMAGE)
		
		if(isliving(L))
			L.add_movespeed_modifier(/datum/movespeed_modifier/solar_dazzle)
			addtimer(CALLBACK(src, PROC_REF(RemoveDazzle), L), 4 SECONDS)

/obj/item/ego_weapon/branch12/solar_day/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	
	if(flash_cooldown > world.time)
		to_chat(user, span_warning("The solar energy hasn't recharged yet."))
		return
	
	flash_cooldown = world.time + flash_cooldown_time
	to_chat(user, span_notice("You unleash a blinding solar flash!"))
	playsound(user, 'sound/weapons/flash.ogg', 100, TRUE)
	
	// Create flash effect
	for(var/mob/living/L in viewers(5, user))
		if(L == user)
			continue
		
		if(isliving(L))
			L.add_movespeed_modifier(/datum/movespeed_modifier/solar_flash)
			addtimer(CALLBACK(src, PROC_REF(RemoveFlash), L), 2 SECONDS)
			L.deal_damage(15, WHITE_DAMAGE)
			to_chat(L, span_userdanger("You are dazzled by the solar flash!"))

//Golden Needle
/obj/item/ego_weapon/branch12/mini/gold_needle
	name = "Gold Needle"
	desc = "A needle that is made of gold, and a red "
	special = "When throwing this weapon, cause Slowdown on hit."
	icon_state = "needle"
	force = 26
	damtype = RED_DAMAGE
	throwforce = 35
	throw_speed = 1
	throw_range = 7
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	attribute_requirements = list(
							TEMPRANCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/branch12/mini/gold_needle/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.apply_status_effect(/datum/status_effect/qliphothoverload)
	..()



//Something Memorable and The Big Day
/obj/item/ego_weapon/ranged/branch12/memorable
	name = "Something Memorable"
	desc = "It's something memorable, something to believe in."
	icon_state = "something_memorable"
	inhand_icon_state = "something_memorable"
	special = "Use in hand to load bullets. Bullets fire in a 3x3 AOE."
	force = 20
	projectile_path = /obj/projectile/ego_bullet/memorable
	weapon_weight = WEAPON_HEAVY
	spread = 5
	recoil = 1.5
	fire_sound = 'sound/weapons/gun/rifle/shot_atelier.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 30
	fire_delay = 15

	attribute_requirements = list(JUSTICE_ATTRIBUTE = 40)
	shotsleft = 4
	reloadtime = 1 SECONDS


/obj/item/ego_weapon/ranged/branch12/memorable/reload_ego(mob/user)
	if(shotsleft == initial(shotsleft))
		return
	is_reloading = TRUE
	to_chat(user,"<span class='notice'>You start loading a bullet.</span>")
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
		shotsleft +=1
	is_reloading = FALSE


/obj/item/ego_weapon/ranged/branch12/memorable/big_day
	name = "A Big Day"
	desc = "It's finally here, the time to use this."
	icon_state = "the_edge"
	inhand_icon_state = "the_edge"
	force = 20
	weapon_weight = WEAPON_MEDIUM
	recoil = 2
	fire_sound_volume = 30
	fire_delay = 12

	shotsleft = 1
	reloadtime = 1.2 SECONDS

/obj/projectile/ego_bullet/memorable
	name = "memorable"
	damage = 35 // Direct hit
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/memorable/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/mob/living/L in view(1, target))
		new /obj/effect/temp_visual/fire/fast(get_turf(L))
		L.apply_damage(45, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT


/obj/item/ego_weapon/branch12/solar_day/proc/RemoveDazzle(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/solar_dazzle)

/obj/item/ego_weapon/branch12/solar_day/proc/RemoveFlash(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/solar_flash)

/datum/movespeed_modifier/solar_dazzle
	variable = TRUE
	multiplicative_slowdown = 1

/datum/movespeed_modifier/solar_flash
	variable = TRUE
	multiplicative_slowdown = 3

//Exterminator
/obj/item/ego_weapon/ranged/branch12/mini/exterminator
	name = "exterminator"
	desc = "A gun that's made to take out pests."
	special = "This weapon inflicts 1 Mental Decay with each shot, and the first bullet of each mag inflicts Mental Detonation. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "exterminator"
	inhand_icon_state = "exterminator"
	force = 14
	projectile_path = /obj/projectile/ego_bullet/branch12/exterminator
	fire_delay = 7
	spread = 10
	shotsleft = 10
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	var/inflicted_decay = 1
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/branch12/mini/exterminator/before_firing(atom/target, mob/user)
	if(shotsleft == initial(shotsleft))
		projectile_path = /obj/projectile/ego_bullet/branch12/exterminator/first

/obj/item/ego_weapon/ranged/branch12/mini/exterminator/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	. = ..()
	projectile_path = /obj/projectile/ego_bullet/branch12/exterminator

/obj/projectile/ego_bullet/branch12/exterminator
	name = "exterminator"
	damage = 20
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/branch12/exterminator/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!istype(fired_from, /obj/item/ego_weapon/ranged/branch12/mini/exterminator) || !isliving(target))
		return
	var/obj/item/ego_weapon/ranged/branch12/mini/exterminator/gun = fired_from
	var/mob/living/target_hit = target
	target_hit.apply_lc_mental_decay(gun.inflicted_decay)

/obj/projectile/ego_bullet/branch12/exterminator/first
	name = "marking exterminator"

/obj/projectile/ego_bullet/branch12/exterminator/first/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/target_hit = target
	target_hit.apply_status_effect(/datum/status_effect/mental_detonate)
