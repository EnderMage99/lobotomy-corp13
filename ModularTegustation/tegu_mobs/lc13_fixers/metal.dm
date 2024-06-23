/mob/living/simple_animal/hostile/humanoid/fixer/metal
	name = "Metal Fixer"
	desc = "A dude covered in a full white cloak and always wear a white mask. He seems to be wearing a tactical vest."
	icon_state = "metal_fixer"
	icon_living = "metal_fixer"
	icon_dead = "metal_fixer"
	var/icon_attacking = "metal_fixer_weapon"
	maxHealth = 1500
	health = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.3)
	move_to_delay = 5
	melee_damage_lower = 12
	melee_damage_upper = 16
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	attack_sound = 'sound/weapons/fixer/generic/blade3.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	del_on_death = TRUE
	ranged = TRUE
	var/statue_type = /mob/living/simple_animal/hostile/metal_fixer_statue
	var/shots_cooldown = 50
	var/max_statues = 12
	var/health_lost_per_statue = 100
	var/list/statues = list()
	var/current_healthloss = 0
	var/aoe_cooldown = 150
	var/last_aoe_time = 0
	var/aoe_damage = 50
	var/stun_duration = 50
	var/spike_line_cooldown = 150
	var/last_spike_line_time = 0
	var/creation_line_cooldown = 100
	var/last_creation_line_time = 0
	var/statue_cooldown = 25
	var/last_statue_cooldown_time = 0
	var/self_damage_statue = 250

/mob/living/simple_animal/hostile/humanoid/fixer/metal/Aggro()
	icon_state = icon_attacking
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/LoseTarget()
	icon_state = icon_living
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/OpenFire()
	ranged_cooldown = world.time + shots_cooldown
	if (world.time > last_spike_line_time + spike_line_cooldown)
		last_spike_line_time = world.time
		say("Experience is what brought me here.")

	playsound(src, 'sound/weapons/fixer/hana_pierce.ogg', 50, TRUE, 2) // pick sound
	for(var/d in GLOB.cardinals)
		var/turf/E = get_step(src, d)
		shoot_projectile(E)

/mob/living/simple_animal/hostile/humanoid/fixer/metal/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE

	if (ranged_cooldown <= world.time)
		OpenFire()

	// do AOE
	if (world.time > last_aoe_time + aoe_cooldown)
		last_aoe_time = world.time
		can_act = FALSE
		say("This is the culmination of my work.")
		SLEEP_CHECK_DEATH(20)
		var/hit_statue = FALSE
		for(var/turf/T in view(2, src))
			playsound(src, 'sound/weapons/fixer/generic/finisher2.ogg', 75, TRUE, 2)
			new /obj/effect/temp_visual/slice(T)
			for(var/mob/living/L in T)
				if (istype(L, /mob/living/simple_animal/hostile/metal_fixer_statue))
					var/mob/living/simple_animal/hostile/metal_fixer_statue/S = L
					qdel(S)
					hit_statue = TRUE
			HurtInTurf(T, list(), aoe_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)

		if (hit_statue)
			say("...")
			adjustHealth(self_damage_statue)
			var/mutable_appearance/colored_overlay = mutable_appearance(icon, "small_stagger", layer + 0.1)
			add_overlay(colored_overlay)
			SLEEP_CHECK_DEATH(stun_duration)
			cut_overlays()
		can_act = TRUE
	else
		. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	//say("Damage taken. Current health: [health]")
	var/old_health = health
	. = ..()
	var/health_loss = old_health - health
	current_healthloss += health_loss
	if (current_healthloss > health_lost_per_statue)
		current_healthloss -= health_lost_per_statue
		spawn_statue()

/mob/living/simple_animal/hostile/humanoid/fixer/metal/proc/spawn_statue()
	if (statues.len < max_statues && world.time > last_statue_cooldown_time + statue_cooldown)
		last_statue_cooldown_time = world.time
		var/list/available_turfs = list()
		for(var/turf/T in view(4, loc))
			if(isfloorturf(T) && !T.density && !locate(/mob/living) in T)
				available_turfs += T
		visible_message("<span class='danger'>[src] starts spawning a statue!</span>")
		if (world.time > last_creation_line_time + creation_line_cooldown)
			last_creation_line_time = world.time
			say("The days of the past.")

		if(available_turfs.len)
			var/turf/statue_turf = pick(available_turfs)
			var/mob/living/simple_animal/hostile/metal_fixer_statue/S = new statue_type(statue_turf)
			statues += S
			S.metal = src
			S.icon_state = "memory_statute_grow" // Set the initial icon state to the rising animation
			flick("memory_statute_grow", S) // Play the rising animation
			spawn(10) // Wait for the animation to finish
				S.icon_state = initial(S.icon_state) // Set the icon state back to the default statue icon
			visible_message("<span class='danger'>[src] spawns a statue. </span>")

/mob/living/simple_animal/hostile/humanoid/fixer/metal/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/metal_fixer(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/mob/living/simple_animal/hostile/humanoid/fixer/metal/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if (istype(P, /obj/projectile/metal_fixer))
		adjustHealth(-(P.damage/4))
		playsound(src, 'sound/abnormalities/voiddream/skill.ogg', 50, TRUE, 2)
		visible_message("<span class='warning'>[P]  contacts with [src] and heals them!</span>")
		DamageEffect(P.damage, P.damage_type)
	else
		. = ..()

/obj/projectile/metal_fixer
	name ="metal bolt"
	icon_state= "chronobolt"
	damage = 25
	speed = 1
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	ricochet_incidence_leeway = 0

/obj/projectile/metal_fixer/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/metal_fixer/on_hit(atom/target, blocked = FALSE)
	if(firer==target)
		//var/mob/living/simple_animal/hostile/humanoid/fixer/metal/M = target
		qdel(src)
		return BULLET_ACT_BLOCK
	. = ..()


/mob/living/simple_animal/hostile/metal_fixer_statue
	name = "Memory Statue"
	desc = "A statue created by the Metal Fixer."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "memory_statute"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	health = 100
	maxHealth = 100
	speed = 0
	move_resist = INFINITY
	mob_size = MOB_SIZE_HUGE
	var/mob/living/simple_animal/hostile/humanoid/fixer/metal/metal
	var/heal_cooldown = 50
	var/heal_timer
	var/heal_per_tick = 25
	var/self_destruct_timer


/mob/living/simple_animal/hostile/metal_fixer_statue/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if (istype(P, /obj/projectile/metal_fixer))
		DamageEffect(P.damage, P.damage_type)
	else
		. = ..()


/mob/living/simple_animal/hostile/metal_fixer_statue/Initialize()
	. = ..()
	heal_timer = addtimer(CALLBACK(src, .proc/heal_metal_fixer), heal_cooldown, TIMER_STOPPABLE)
	self_destruct_timer = addtimer(CALLBACK(src, .proc/self_destruct), 0.5 MINUTES, TIMER_STOPPABLE)
	AIStatus = AI_OFF
	stop_automated_movement = TRUE
	anchored = TRUE

/mob/living/simple_animal/hostile/metal_fixer_statue/Destroy()
	deltimer(heal_timer)
	deltimer(self_destruct_timer)
	return ..()

/mob/living/simple_animal/hostile/metal_fixer_statue/proc/self_destruct()
	visible_message("<span class='danger'>The statue crumbles and self-destructs!</span>")
	qdel(src)

/mob/living/simple_animal/hostile/metal_fixer_statue/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(health <= 0)
		visible_message("<span class='danger'>The statue crumbles into pieces!</span>")
		qdel(src)

/mob/living/simple_animal/hostile/metal_fixer_statue/proc/heal_metal_fixer()
	if(metal)
		metal.adjustHealth(-heal_per_tick)
		visible_message("<span class='notice'>The statue heals the Metal Fixer!</span>")
		playsound(src, 'sound/abnormalities/rosesign/rose_summon.ogg', 75, TRUE, 2)
		icon_state = "memory_statute_heal" // Set the initial icon state to the rising animation
		flick("memory_statute_heal", src) // Play the rising animation
		spawn(10) // Wait for the animation to finish
			icon_state = initial(icon_state) // Set the icon state back to the default statue icon
	heal_timer = addtimer(CALLBACK(src, .proc/heal_metal_fixer), heal_cooldown, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/metal_fixer_statue/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/metal_fixer_statue/CanAttack(atom/the_target)
	return FALSE
