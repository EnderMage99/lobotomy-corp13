/obj/item/book/granter/action/skill/shockwave
	granted_action = /datum/action/cooldown/shockwave
	actionname = "Shockwave"
	name = "Level 2 Skill: Shockwave"
	level = 2

/datum/action/cooldown/shockwave
	icon_icon = 'icons/hud/screen_skills.dmi'
	name = "Shockwave"
	button_icon_state = "shockwave"
	cooldown_time = 150
	var/range = 4
	var/stun_amt = 60
	var/maxthrow = 5
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG

/datum/action/cooldown/shockwave/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat)
		return FALSE

	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	//playMagSound()
	var/list/targets = list()
	var/user = owner

	for(var/turf/target in view(range, user))
		targets += target

	for(var/turf/T in targets) //Done this way so things don't get thrown all around hilariously.
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored || !isliving(AM) || ishuman(AM))
			continue

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(distfromcaster == 0)
			var/mob/living/M = AM
			M.Immobilize(stun_amt, ignore_canstun = TRUE)
			M.adjustRedLoss(50)
			to_chat(M, "<span class='userdanger'>You're slammed into the floor by [user]!</span>")
		else
			new /obj/effect/temp_visual/gravpush(get_turf(AM), get_dir(user, AM)) //created sparkles will disappear on their own
			var/mob/living/M = AM
			M.Immobilize(stun_amt * 0.5, ignore_canstun = TRUE)
			to_chat(M, "<span class='userdanger'>You're thrown back by [user]!</span>")
			AM.safe_throw_at(throwtarget, ((clamp((maxthrow - (clamp(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)//So stuff gets tossed around at the same time.
	StartCooldown()


/obj/item/book/granter/action/skill/combo
	granted_action = /datum/action/cooldown/combo
	actionname = "Combo"
	name = "Level 2 Skill: Combo"
	level = 2


/datum/action/cooldown/combo
	icon_icon = 'icons/hud/screen_skills.dmi'
	name = "Combo"
	button_icon_state = "shockwave"
	cooldown_time = 10

/datum/action/cooldown/combo/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat)
		return FALSE

	if (isliving(owner))
		var/mob/living/M = owner
		M.apply_status_effect(/datum/status_effect/buffed)

/datum/status_effect/buffed
	duration = 80
	var/extra_duration = 20
	var/count = 0
	var/list/items = list()

/datum/status_effect/buffed/on_apply()
	var/applied = FALSE
	for(var/i in 1 to owner.held_items.len)
		var/obj/item/I = owner.get_item_for_held_index(i)
		if (I)
			RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, .proc/do_extra_damage)
			items += I
			to_chat(owner, "<span class='userdanger'>Buff applied to [I]!</span>")
			applied = TRUE
	return applied

/datum/status_effect/buffed/on_remove()
	for (var/obj/item/I in items)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK, .proc/do_extra_damage)
		to_chat(owner, "<span class='userdanger'>Buff removed from [I]! Count [count]</span>")

	if (count == 3)
		owner.Immobilize(20)

/datum/status_effect/buffed/proc/do_extra_damage(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(user.a_intent != INTENT_HARM)
		return

	if(count < 3)
		var/extra_damage = max(0, source.force * count)
		count ++
		duration += extra_duration
		if (isliving(target))
			var/mob/living/M = target
			M.apply_damage(extra_damage, source.damtype, user.zone_selected)
			to_chat(user, "<span class='userdanger'>Extra damage applied to [target]!</span>")
