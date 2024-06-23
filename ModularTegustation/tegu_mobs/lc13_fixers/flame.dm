/mob/living/simple_animal/hostile/humanoid/fixer/flame
	name = "Flame Fixer"
	desc = "A lanky young man with fair skin, dark eyes, and an often overoptimistic expression. A heavy spear decorated with vibrant patterns on the head."
	icon_state = "flame_fixer"
	icon_living = "flame_fixer"
	icon_dead = "flame_fixer"
	maxHealth = 2500
	health = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.3)
	move_to_delay = 4
	melee_damage_lower = 20
	melee_damage_upper = 24
	melee_damage_type = RED_DAMAGE
	rapid_melee = 0.5
	attack_sound = 'sound/weapons/fixer/generic/spear3.ogg'
	attack_verb_continuous = "pierces"
	attack_verb_simple = "pierce"
	del_on_death = TRUE
	ranged = TRUE
	ranged_cooldown_time = 45
	melee_reach = 2
	var/burn_stacks = 2
	projectiletype = /obj/projectile/flame_fixer
	var/damage_reflection = FALSE
	var/dash_cooldown = 150
	var/last_dash = 0
	var/dash_damage = 50
	var/last_counter = 0
	var/counter_cooldown = 30
	var/last_voice_line = 0
	var/voice_line_cooldown = 250

/mob/living/simple_animal/hostile/humanoid/fixer/flame/proc/TripleDash()
	// if dash is off cooldown stun until the end of dashes and say quote
	// wait 2 sec for the first dash
	// after 2 sec dash towards the target dealing red dmg and applying burn
	// repeat 3 times with 1 sec delay between each
	// unstun
	if (world.time > last_dash + dash_cooldown)
		last_dash = world.time
		can_act = FALSE
		say("Dissatisfaction.")
		icon_state = "flame_fixer_dashing"
		SLEEP_CHECK_DEATH(20)
		Dash(target)
		Dash(target)
		Dash(target)
		icon_state = initial(icon_state)
		last_dash = world.time
		can_act = TRUE

/mob/living/simple_animal/hostile/humanoid/fixer/flame/proc/Dash(dash_target)
	if (!dash_target)
		return
	var/turf/target_turf = get_turf(dash_target)
	var/list/hit_mob = list()
	//do_shaky_animation(2)
	if(do_after(src, 0.5 SECONDS, target = src))
		var/turf/wallcheck = get_turf(src)
		var/enemy_direction = get_dir(src, target_turf)
		for(var/i=0 to 7)
			if(get_turf(src) != wallcheck || stat == DEAD )
				break
			wallcheck = get_step(src, enemy_direction)
			if(!ClearSky(wallcheck))
				break
			//without this the attack happens instantly
			sleep(0.5)
			forceMove(wallcheck)
			playsound(wallcheck, 'sound/weapons/ego/burn_sword.ogg', 20, 0, 4)
			for(var/turf/T in orange(get_turf(src), 1))
				if(isclosedturf(T))
					continue
				new /obj/effect/temp_visual/mech_fire(T)
				for(var/mob/living/L in T)
					if(!faction_check_mob(L, FALSE) || locate(L) in hit_mob)
						L.apply_damage(dash_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
						LAZYADD(hit_mob, L)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/proc/ClearSky(turf/T)
	if(!T || isclosedturf(T) || T == loc)
		return FALSE
	if(locate(/obj/structure/window) in T.contents)
		return FALSE
	if(locate(/obj/structure/table) in T.contents)
		return FALSE
	if(locate(/obj/structure/railing) in T.contents)
		return FALSE
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			return FALSE
	return TRUE


/mob/living/simple_animal/hostile/humanoid/fixer/flame/OpenFire(atom/A)
	if (!can_act)
		return
	TripleDash()
	. = ..()

/mob/living/simple_animal/hostile/humanoid/fixer/flame/Shoot(atom/targeted_atom)
	var/obj/projectile/flame_fixer/P = ..()
	P.set_homing_target(target)
	if (world.time > last_voice_line + voice_line_cooldown)
		say("Helios fire!")
		last_voice_line = world.time

/mob/living/simple_animal/hostile/humanoid/fixer/flame/AttackingTarget(atom/attacked_target)
	// check cooldown and start countering
	// stop melee start stun for 4 sec
	// animate windup  for 1 sec
	// change icon_state to counter
	// if they hit after wind up during counter deal RED damage and stamina damage
	// counter has random cooldown 15-40 sec
	if (!can_act)
		return
	TripleDash()

	if (world.time > last_counter + counter_cooldown)
		last_counter = world.time
		can_act = FALSE
		icon_state = "flame_fixer_counter_start"
		say("Debilitation.")
		SLEEP_CHECK_DEATH(10)
		damage_reflection = TRUE
		icon_state = "flame_fixer_counter"
		SLEEP_CHECK_DEATH(40)
		damage_reflection = FALSE
		can_act = TRUE
		icon_state = initial(icon_state)
		last_counter = world.time
		counter_cooldown = rand(100, 250)
		return

	. = ..()
	if (istype(target, /mob/living))
		var/mob/living/L = target
		L.apply_lc_burn(burn_stacks)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		if(get_dist(Proj.firer, src) < 8)
			ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!damage_reflection)
		return
	ReflectDamage(user, I.damtype, I.force)

/mob/living/simple_animal/hostile/humanoid/fixer/flame/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	var/turf/jump_turf = get_step(attacker, pick(GLOB.alldirs))
	if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
		jump_turf = get_turf(attacker)
	forceMove(jump_turf)
	playsound(src, 'sound/weapons/ego/burn_guard.ogg', min(15 + damage, 75), TRUE, 4)
	attacker.visible_message(span_danger("[src] hits [attacker] with a counterattack!"), span_userdanger("[src] counters your attack!"))
	do_attack_animation(attacker)
	attacker.apply_damage(damage * 2, attack_type, null, attacker.getarmor(null, attack_type))
	attacker.apply_damage(damage, STAMINA, null, null)



/obj/projectile/flame_fixer
	name ="flame bolt"
	icon_state= "helios_fire"
	damage = 15
	speed = 8
	damage_type = RED_DAMAGE
	//projectile_piercing = PASSMOB
	ricochets_max = 20
	ricochet_chance = 100
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	ricochet_incidence_leeway = 0
	homing = TRUE
	homing_turn_speed = 10		//Angle per tick.
	var/stun_duration = 75
	var/burn_stacks = 20


/obj/projectile/flame_fixer/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/flame_fixer/on_hit(atom/target, blocked = FALSE)
	if (istype(target, /mob/living))
		var/mob/living/L = target
		L.apply_lc_burn(burn_stacks)
	if(firer==target)
		var/mob/living/simple_animal/hostile/humanoid/fixer/flame/F = target
		qdel(src)
		F.can_act = FALSE
		F.say("Derealization...")
		var/mutable_appearance/colored_overlay = mutable_appearance(F.icon, "small_stagger", F.layer + 0.1)
		F.add_overlay(colored_overlay)
		sleep(stun_duration)
		F.cut_overlays()
		F.can_act = TRUE
		return BULLET_ACT_BLOCK
	. = ..()
