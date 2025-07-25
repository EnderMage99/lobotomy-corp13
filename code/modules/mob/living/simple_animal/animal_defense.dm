

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M)
	// so that martial arts don't double dip
	if (..())
		return TRUE
	switch(M.a_intent)
		if("help")
			if (stat == DEAD)
				return
			visible_message(span_notice("[M] [response_help_continuous] [src]."), \
							span_notice("[M] [response_help_continuous] you."), null, null, M)
			to_chat(M, span_notice("You [response_help_simple] [src]."))
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
			if(pet_bonus)
				funpet(M)

		if("grab")
			grabbedby(M)

		if("disarm")
			M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
			var/shove_dir = get_dir(M, src)
			if(!Move(get_step(src, shove_dir), shove_dir))
				log_combat(M, src, "shoved", "failing to move it")
				M.visible_message(span_danger("[M.name] shoves [src]!"),
					span_danger("You shove [src]!"), span_hear("You hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE, list(src))
				to_chat(src, span_userdanger("You're shoved by [M.name]!"))
				return TRUE
			log_combat(M, src, "shoved", "pushing it")
			M.visible_message(span_danger("[M.name] shoves [src], pushing [p_them()]!"),
				span_danger("You shove [src], pushing [p_them()]!"), span_hear("You hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE, list(src))
			to_chat(src, span_userdanger("You're pushed by [M.name]!"))
			return TRUE

		if("harm")
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, span_warning("You don't want to hurt [src]!"))
				return
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			visible_message(span_danger("[M] [response_harm_continuous] [src]!"),\
							span_userdanger("[M] [response_harm_continuous] you!"), null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("You [response_harm_simple] [src]!"))
			playsound(loc, attacked_sound, 25, TRUE, -1)
			attack_threshold_check(harm_intent_damage)
			log_combat(M, src, "attacked")
			updatehealth()
			return TRUE

/**
*This is used to make certain mobs (pet_bonus == TRUE) emote when pet, and make a heart emoji at their location.
*
*/
/mob/living/simple_animal/proc/funpet(mob/petter)
	new /obj/effect/temp_visual/heart(loc)
	if(prob(33))
		manual_emote("[pet_bonus_emote]")

/mob/living/simple_animal/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	playsound(loc, "punch", 25, TRUE, -1)
	visible_message(span_danger("[user] punches [src]!"), \
					span_userdanger("You're punched by [user]!"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You punch [src]!"))
	adjustBruteLoss(15)

/mob/living/simple_animal/attack_paw(mob/living/carbon/human/M)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			var/damage = rand(1, 3)
			attack_threshold_check(damage)
			return 1
	if (M.a_intent == INTENT_HELP)
		if (health > 0)
			visible_message(span_notice("[M.name] [response_help_continuous] [src]."), \
							span_notice("[M.name] [response_help_continuous] you."), null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_notice("You [response_help_simple] [src]."))
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)


/mob/living/simple_animal/attack_alien(mob/living/carbon/alien/humanoid/M)
	if(..()) //if harm or disarm intent.
		if(M.a_intent == INTENT_DISARM)
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			visible_message(span_danger("[M] [response_disarm_continuous] [name]!"), \
							span_userdanger("[M] [response_disarm_continuous] you!"), null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("You [response_disarm_simple] [name]!"))
			log_combat(M, src, "disarmed")
		else
			var/damage = rand(15, 30)
			visible_message(span_danger("[M] slashes at [src]!"), \
							span_userdanger("You're slashed at by [M]!"), null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("You slash at [src]!"))
			playsound(loc, 'sound/weapons/slice.ogg', 25, TRUE, -1)
			attack_threshold_check(damage)
			log_combat(M, src, "attacked")
		return 1

/mob/living/simple_animal/attack_larva(mob/living/carbon/alien/larva/L)
	. = ..()
	if(. && stat != DEAD) //successful larva bite
		var/damage = rand(5, 10)
		. = attack_threshold_check(damage)
		if(.)
			L.amount_grown = min(L.amount_grown + damage, L.max_grown)

/mob/living/simple_animal/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		return attack_threshold_check(rand(M.melee_damage_lower, M.melee_damage_upper), M.melee_damage_type) //Fixing a 1 year old bug...

/mob/living/simple_animal/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime attack
		var/damage = rand(15, 25)
		if(M.is_adult)
			damage = rand(20, 35)
		return attack_threshold_check(damage)

/mob/living/simple_animal/attack_drone(mob/living/simple_animal/drone/M)
	if(M.a_intent == INTENT_HARM) //No kicking dogs even as a rogue drone. Use a weapon.
		return
	return ..()

/mob/living/simple_animal/proc/attack_threshold_check(damage, damagetype = BRUTE, actuallydamage = TRUE)
	var/temp_damage = damage

	if(islist(damage_coeff))
		ChangeResistances(damage_coeff)
		stack_trace("[src] has a damage_coeff list and was hurt!")
	else if(!istype(damage_coeff))
		stack_trace("[src] has an invalid damage coeff entirely!? Resetting to default.")
		if(!istype(unmodified_damage_coeff_datum))
			stack_trace("[src] has an invalid unmodified damage coeff!? Resetting to 1s")
			unmodified_damage_coeff_datum = makeDamCoeff()
		damage_coeff = unmodified_damage_coeff_datum
		UpdateResistances()
	temp_damage *= damage_coeff.getCoeff(damagetype)

	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message(span_warning("[src] looks unharmed!"))
		DamageEffect(0, damagetype)
		return FALSE

	if(actuallydamage)
		apply_damage(damage, damagetype, null, getarmor(null, damagetype))
	return TRUE

/mob/living/simple_animal/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	if(projectile_blockers && projectile_blockers.len > 0)
		for(var/i in projectile_blockers)
			Proj.impacted[i] = TRUE
		Proj.impacted[src] = TRUE
	apply_damage(Proj.damage, Proj.damage_type)
	Proj.on_hit(src, 0, piercing_hit)
	return BULLET_ACT_HIT

/mob/living/simple_animal/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()
	if(QDELETED(src))
		return
	var/bomb_armor = getarmor(null, BOMB)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(prob(bomb_armor))
				adjustBruteLoss(500)
			else
				gib()
				return
		if (EXPLODE_HEAVY)
			var/bloss = 60
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

		if(EXPLODE_LIGHT)
			var/bloss = 30
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

/mob/living/simple_animal/blob_act(obj/structure/blob/B)
	adjustBruteLoss(20)
	return

/mob/living/simple_animal/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(attack_vis_effect && !iswallturf(A)) // override the standard visual effect.
			visual_effect_icon = attack_vis_effect
		else if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
