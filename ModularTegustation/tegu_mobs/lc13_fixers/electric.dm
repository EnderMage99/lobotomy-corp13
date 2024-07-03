/mob/living/simple_animal/hostile/humanoid/fixer/electric
	name = "Electric Fixer"
	desc = "Feminine guy, dressed in mainly black with neon accents, with bright amber eyes."
	icon_state = "electric_fixer"
	icon_living = "electric_fixer"
	icon_dead = "electric_fixer"
	maxHealth = 1500
	health = 1500
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 20
	melee_damage_type = WHITE_DAMAGE
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	ranged = TRUE
  //  attack_sound = 'sound/weapons/tase.ogg'

	var/ramp_up = 0
	var/showtime = FALSE
	var/showtime_duration = 10 SECONDS
	var/stun_duration = 8 SECONDS
	var/dash_range = 7

	var/base_ability_windup = 3 SECONDS

/mob/living/simple_animal/hostile/humanoid/fixer/electric/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/KillPanicked(mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.sanity_lost)
			H.death()

/mob/living/simple_animal/hostile/humanoid/fixer/electric/AttackingTarget()
	. = ..()
	KillPanicked(target)

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/increase_ramp_up()
	ramp_up++
	if(ramp_up >= 10 && !showtime)
		start_showtime()

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/start_showtime()
	showtime = TRUE
	ramp_up = 15
	addtimer(CALLBACK(src, .proc/end_showtime), showtime_duration)

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/end_showtime()
	showtime = FALSE
	ramp_up = 0
	Stun(stun_duration)

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/get_windup_time()
	return max(0.5 SECONDS, base_ability_windup - (ramp_up * 0.1 SECONDS))

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/blazing_dash()

	var/dash_damage = showtime ? 5 : 20  // 75% less damage during showtime
	can_act = FALSE

	for(var/i in 1 to 2)
		var/windup_time = get_windup_time()
		visible_message("<span class='warning'>[src] prepares to dash!</span>")

		var/turf/slash_start = get_turf(src)
		var/turf/slash_end = get_ranged_target_turf_direct(slash_start, target, dash_range)
		var/list/hitline = getline(slash_start, slash_end)
		face_atom(target)
		for(var/turf/T in hitline)
			new /obj/effect/temp_visual/cult/sparks(T)

		var/turf/T = get_turf(target)
		SLEEP_CHECK_DEATH(windup_time)
		forceMove(slash_end)
		// for(var/turf/T in hitline)
		// 	for(var/mob/living/L in HurtInTurf(T, list(), dash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE))
		// 		to_chat(L, span_userdanger("[src] quickly slashes you!"))
		new /datum/beam(slash_start.Beam(slash_end, "1-full", time=3))
		playsound(src, attack_sound, 50, FALSE, 4)

		for(var/mob/living/L in T)
			if(L != src)
				L.apply_damage(dash_damage, WHITE_DAMAGE)
				KillPanicked(L)

	can_act = TRUE

	increase_ramp_up()

	var rnd = rand(1, 4)
	if(rnd < 3)
		blazing_dash()
	else if(rnd == 3)
		fantasia_lights()
	else
		amber_circuits()

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/fantasia_lights()
	// if(world.time < fantasia_lights_cooldown)
	// 	return

	// fantasia_lights_cooldown = world.time + 5 SECONDS

	// var/jump_damage = showtime ? 5 : 20  // 75% less damage during showtime

	// visible_message("<span class='warning'>[src] leaps into the air!</span>")
	// var/windup_time = get_windup_time()
	// stoplag(windup_time)

	// if(QDELETED(src) || stat == DEAD)
	// 	return

	// var/turf/T = get_turf(target)
	// forceMove(T)
	// for(var/mob/living/L in T)
	// 	if(L != src)
	// 		L.apply_damage(jump_damage, WHITE_DAMAGE)
	// 		KillPanicked(L)

	// increase_ramp_up()

	// if(prob(50))
	// 	fantasia_lights()
	// else if(prob(33))
	// 	blazing_dash()
	// else if(prob(50))
	// 	amber_circuits()

/mob/living/simple_animal/hostile/humanoid/fixer/electric/proc/amber_circuits()
	// if(world.time < amber_circuits_cooldown)
	// 	return

	// amber_circuits_cooldown = world.time + 5 SECONDS

	// var/circuit_damage = showtime ? 5 : 20  // 75% less damage during showtime

	// visible_message("<span class='warning'>[src] begins to glow with electrical energy!</span>")
	// var/windup_time = get_windup_time()

	// var/list/circuit_turfs = list()
	// for(var/turf/T in orange(3, src))
	// 	if(get_dist(src, T) % 2 == 0)
	// 		circuit_turfs += T
	// 		new /obj/effect/temp_visual/electric_sparks(T)

	// stoplag(windup_time)

	// if(QDELETED(src) || stat == DEAD)
	// 	return

	// for(var/turf/T in circuit_turfs)
	// 	for(var/mob/living/L in T)
	// 		if(L != src)
	// 			L.apply_damage(circuit_damage, WHITE_DAMAGE)
	// 			KillPanicked(L)

	// increase_ramp_up()

	// if(prob(50))
	// 	amber_circuits()
	// else if(prob(33))
	// 	blazing_dash()
	// else if(prob(50))
	// 	fantasia_lights()

/mob/living/simple_animal/hostile/humanoid/fixer/electric/OpenFire()
	var rnd = rand(1, 3)
	if(rnd == 1)
		blazing_dash()
	else if(rnd == 2)
		fantasia_lights()
	else
		amber_circuits()

/obj/effect/temp_visual/electric_sparks
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 3 SECONDS

