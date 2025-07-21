
// --------TETH---------
//Departure
/obj/item/ego_weapon/branch12/departure
	name = "Departure"
	desc = "Each man's death diminishes me, For I am involved in mankind"
	special = "Upon hitting living target, Inflict 4 Bleed to the target and gain 1 Bleed."
	icon_state = "departure"
	force = 8
	attack_speed = 0.5
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	var/inflicted_bleed = 4
	var/gained_bleed = 1

/obj/item/ego_weapon/branch12/departure/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_bleed(inflicted_bleed)
	if(isliving(user))
		user.apply_lc_bleed(gained_bleed)

//Misfortune
/obj/item/ego_weapon/branch12/misfortune
	name = "Misfortune"
	desc = "Don't worry, you want it, I got it."
	special = "This weapon has a chance to trip enemies on hit, dealing extra damage and stunning them briefly. \
	Every third successful hit will cause the target to become drugged, decreasing their movement speed. \
	If you use this weapon in hand, you will gain a brief speed boost but take minor toxin damage."
	icon_state = "misfortune"
	force = 18
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pranks", "tricks", "jests")
	attack_verb_simple = list("prank", "trick", "jest")
	hitsound = 'sound/items/bikehorn.ogg'
	var/hits_to_drug = 3
	var/hit_counter = 0
	var/trip_chance = 40
	var/trip_damage = 10
	var/self_use_cooldown
	var/self_use_cooldown_time = 10 SECONDS

/obj/item/ego_weapon/branch12/misfortune/attack(mob/living/target, mob/living/user)
	...
	if(!isliving(target))
		return

	hit_counter++

	// Trip mechanic
	if(prob(trip_chance))
		to_chat(target, span_userdanger("Your shoelaces suddenly tie themselves together!"))
		if(isliving(target))
			var/mob/living/L = target
			L.add_movespeed_modifier(/datum/movespeed_modifier/misfortune_trip)
			addtimer(CALLBACK(src, PROC_REF(RemoveTripSlow), L), 2 SECONDS)
			L.deal_damage(trip_damage, BLACK_DAMAGE)
		playsound(target, 'sound/misc/slip.ogg', 50, TRUE)

	// Confusion mechanic every third hit
	if(hit_counter >= hits_to_drug)
		hit_counter = 0
		if(isliving(target))
			var/mob/living/L = target
			L.add_movespeed_modifier(/datum/movespeed_modifier/misfortune_confused)
			addtimer(CALLBACK(src, PROC_REF(RemoveConfusion), L), 5 SECONDS)
		to_chat(target, span_warning("You feel a tiny prick..."))

/obj/item/ego_weapon/branch12/misfortune/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(self_use_cooldown < world.time)
		self_use_cooldown = world.time + self_use_cooldown_time
		to_chat(H, span_notice("You feel mischievous energy coursing through you!"))
		H.add_movespeed_modifier(/datum/movespeed_modifier/mischief)
		addtimer(CALLBACK(src, PROC_REF(RemoveSpeed), H), 5 SECONDS)
		H.deal_damage(5, BLACK_DAMAGE)
		playsound(H, 'sound/effects/smoke.ogg', 50, TRUE)
	else
		to_chat(H, span_warning("The mischievous energy hasn't recharged yet."))

/obj/item/ego_weapon/branch12/misfortune/proc/RemoveSpeed(mob/living/carbon/human/H)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/mischief)

/obj/item/ego_weapon/branch12/misfortune/proc/RemoveTripSlow(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/misfortune_trip)

/obj/item/ego_weapon/branch12/misfortune/proc/RemoveConfusion(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/misfortune_confused)

/datum/movespeed_modifier/mischief
	variable = TRUE
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/misfortune_trip
	variable = TRUE
	multiplicative_slowdown = 2

/datum/movespeed_modifier/misfortune_confused
	variable = TRUE
	multiplicative_slowdown = 0.5

//Forest's Gift
/obj/item/ego_weapon/branch12/forest_gift
	name = "Forest's Gift"
	desc = "The forest remembers, and the forest provides."
	special = "This weapon deals massive damage but slows you down while held. \
	Throwing this weapon at enemies will knock them down and deal extreme damage. \
	Every successful hit has a chance to spawn a temporary rock projectile that you can throw."
	icon_state = "forest_gift"
	force = 35
	damtype = RED_DAMAGE
	attack_speed = 1.5
	attack_verb_continuous = list("crushes", "pulverizes", "demolishes")
	attack_verb_simple = list("crush", "pulverize", "demolish")
	hitsound = 'sound/weapons/smash.ogg'
	throwforce = 60
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 2
	item_flags = SLOWS_WHILE_IN_HAND
	var/rock_spawn_chance = 25

/obj/item/ego_weapon/branch12/forest_gift/attack(mob/living/target, mob/living/user)
	...
	if(!isliving(target))
		return

	// Chance to spawn a throwable rock
	if(prob(rock_spawn_chance))
		var/turf/T = get_turf(user)
		new /obj/item/forest_pebble(T)
		to_chat(user, span_notice("A pebble falls from [src]!"))
		playsound(T, 'sound/effects/break_stone.ogg', 50, TRUE)

/obj/item/ego_weapon/branch12/forest_gift/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	...
	if(!isliving(hit_atom))
		return
	var/mob/living/L = hit_atom
	L.add_movespeed_modifier(/datum/movespeed_modifier/forest_stun)
	addtimer(CALLBACK(src, PROC_REF(RemoveForestStun), L), 3 SECONDS)
	playsound(L, 'sound/effects/meteorimpact.ogg', 100, TRUE)

// Small throwable rock that spawns
/obj/item/forest_pebble
	name = "forest pebble"
	desc = "A small piece of the forest's memory."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "pebble"
	throwforce = 30
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL

/obj/item/forest_pebble/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(decay)), 30 SECONDS)

/obj/item/forest_pebble/proc/decay()
	visible_message(span_notice("[src] crumbles to dust."))
	qdel(src)

/obj/item/ego_weapon/branch12/forest_gift/proc/RemoveForestStun(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/forest_stun)

/datum/movespeed_modifier/forest_stun
	variable = TRUE
	multiplicative_slowdown = 10

//Acupuncture
/obj/item/ego_weapon/branch12/mini/acupuncture
	name = "Acupuncture"
	desc = "One man's medicine is another man's poison."
	special = "You are able to inject yourself with this weapon. If you inject yourself with the weapon, you will take toxic damage, but gain a 30% damage buff and inflict 3 Mental Decay on hit for 5 seconds. <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "acupuncture"
	force = 20
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	var/inject_cooldown
	var/inject_cooldown_time = 5.1 SECONDS
	var/justice_buff = 30
	var/normal_mental_decay_inflict = 3
	var/mental_decay_inflict = 0

/obj/item/ego_weapon/branch12/mini/acupuncture/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_mental_decay(mental_decay_inflict)

/obj/item/ego_weapon/branch12/mini/acupuncture/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/drugie = user
	if(inject_cooldown < world.time)
		inject_cooldown = world.time + inject_cooldown_time
		drugie.set_drugginess(15)
		drugie.adjustToxLoss(7)
		to_chat(drugie, span_nicegreen("Wow... I can taste the colors..."))
		mental_decay_inflict = normal_mental_decay_inflict
		if(prob(20))
			drugie.emote(pick("twitch","drool","moan","giggle"))
		drugie.adjust_attribute_buff(JUSTICE_ATTRIBUTE, justice_buff)
		addtimer(CALLBACK(src, PROC_REF(RemoveBuff), drugie), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		to_chat(drugie, span_boldwarning("[src] has not refueled yet."))

/obj/item/ego_weapon/branch12/mini/acupuncture/proc/RemoveBuff(mob/user)
	var/mob/living/carbon/human/human = user
	mental_decay_inflict = 0
	human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -justice_buff)

//One Starry Night
/obj/item/ego_weapon/ranged/branch12/starry_night
	name = "One Starry Night"
	desc = "A gun that's made to take out pests."
	special = "This weapon deal 1% more damage to abnormalities, per 1% of their understanding. If they have max understanding, this weapon also reduces the target's white resistance by 20% for 5 seconds.<br>\
	You also inflict 1 Mental Decay per 50% understanding the target has. <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "starry_night"
	inhand_icon_state = "starry_night"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/starry_night
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	spread = 10
	shotsleft = 25
	reloadtime = 2.5 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/projectile/ego_bullet/branch12/starry_night
	name = "starry night"
	icon_state = "whitelaser"
	damage = 22
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/branch12/starry_night/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!istype(target, /mob/living/simple_animal/hostile/abnormality))
		return
	var/mob/living/simple_animal/hostile/abnormality/A = target
	var/extra_damage = 0
	if(A.datum_reference)
		extra_damage = (A.datum_reference.understanding / A.datum_reference.max_understanding)
		A.deal_damage(damage*extra_damage, "white")
		A.apply_lc_mental_decay(round(extra_damage*2))
		if(A.datum_reference.understanding == A.datum_reference.max_understanding)
			if(!A.has_status_effect(/datum/status_effect/rend_white))
				new /obj/effect/temp_visual/cult/sparks(get_turf(A))
				A.apply_status_effect(/datum/status_effect/rend_white)


//Slot Machine
/obj/item/ego_weapon/branch12/mini/slot_machine
	name = "Slot Machine"
	desc = "Big money!"
	special = "Upon throwing, this weapon returns to the user. Also, When hitting a foe by throwing this weapon you will inflict Mental Detonation if the target has 15+ Mental Decay. Then you inflict 3 Mental Decay. <br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "coin"
	force = 10
	damtype = RED_DAMAGE
	throwforce = 45
	throw_speed = 1
	throw_range = 7
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	var/detonation_breakpoint = 15
	var/mental_decay_inflict = 3

/obj/item/ego_weapon/branch12/mini/slot_machine/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		mental_inflict(hit_atom, thrownby)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/branch12/mini/slot_machine/proc/mental_inflict(hit_target, thrower)
	if(!ismob(hit_target) && !iscarbon(thrower))
		return
	var/mob/living/T = hit_target
	var/datum/status_effect/stacking/lc_mental_decay/D = T.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
	if(D.stacks >= detonation_breakpoint)
		T.apply_status_effect(/datum/status_effect/mental_detonate)
	T.apply_lc_mental_decay(mental_decay_inflict)

//White Lotus
/obj/item/ego_weapon/branch12/mini/white_lotus
	name = "white lotus"
	desc = "Has a beautiful smell to it."
	icon_state = "white_lotus"
	force = 20
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")

//Black Lotus
/obj/item/ego_weapon/shield/branch12/mini/black_lotus
	name = "black lotus"
	desc = "Has a beautiful smell to it."
	icon_state = "black_lotus"
	special = "Upon throwing, this weapon returns to the user."
	force = 22
	attack_speed = 3
	throwforce = 22
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	reductions = list(20, 20, 50, 20)
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/parry.ogg'
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You reset your buckler."


/obj/item/ego_weapon/shield/branch12/mini/black_lotus/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return

//Workshopping
/obj/item/ego_weapon/branch12/workshopping
	name = "workshopping"
	desc = "A toolbox filled with dubious crafting supplies. Sometimes you get what you pay for, sometimes you don't."
	special = "This weapon randomly changes damage type on each hit. \
	Throwing this weapon creates a fake E.G.O weapon at the impact location that lasts for 30 seconds. \
	Using this weapon in hand has a 50% chance to either upgrade it temporarily or downgrade it."
	icon_state = "workshopping"
	force = 22
	damtype = RED_DAMAGE
	throwforce = 15
	throw_speed = 3
	throw_range = 7
	attack_verb_continuous = list("bashes", "scams", "cheats")
	attack_verb_simple = list("bash", "scam", "cheat")
	hitsound = 'sound/items/drill_use.ogg'
	var/upgraded = FALSE
	var/downgraded = FALSE
	var/upgrade_duration = 20 SECONDS

/obj/item/ego_weapon/branch12/workshopping/attack(mob/living/target, mob/living/user)
	// Random damage type to represent shoddy craftsmanship
	damtype = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

	if(upgraded)
		force = 35
	else if(downgraded)
		force = 10
	else
		force = initial(force)

	. = ..()

	// Small chance to "break" and deal damage to user
	if(prob(5))
		to_chat(user, span_warning("[src] backfires!"))
		user.deal_damage(10, damtype)

/obj/item/ego_weapon/branch12/workshopping/attack_self(mob/user)
	if(!CanUseEgo(user))
		return

	to_chat(user, span_notice("You tinker with [src]..."))
	playsound(user, 'sound/items/screwdriver.ogg', 50, TRUE)

	if(prob(50))
		// Upgrade
		if(!upgraded)
			upgraded = TRUE
			downgraded = FALSE
			to_chat(user, span_nicegreen("You successfully improve the weapon!"))
			addtimer(CALLBACK(src, PROC_REF(reset_stats)), upgrade_duration)
	else
		// Downgrade
		if(!downgraded)
			downgraded = TRUE
			upgraded = FALSE
			to_chat(user, span_warning("You accidentally damage the weapon!"))
			addtimer(CALLBACK(src, PROC_REF(reset_stats)), upgrade_duration)

/obj/item/ego_weapon/branch12/workshopping/proc/reset_stats()
	upgraded = FALSE
	downgraded = FALSE
	if(isliving(loc))
		to_chat(loc, span_notice("[src] returns to its normal state."))

/obj/item/ego_weapon/branch12/workshopping/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	// Spawn a random fake weapon
	var/list/fake_weapons = list(
		/obj/item/ego_weapon/branch12/fake_mimicry,
		/obj/item/ego_weapon/branch12/fake_reverb,
		/obj/item/ego_weapon/branch12/fake_purple_tear,
		/obj/item/ego_weapon/branch12/fake_whitemoon
	)

	var/obj/item/ego_weapon/fake = new (pick(fake_weapons))(get_turf(src))
	if(fake)
		fake.force = fake.force * 0.7 // Weaker than the originals
		addtimer(CALLBACK(fake, TYPE_PROC_REF(/atom, visible_message), span_warning("[fake] crumbles to dust!")), 30 SECONDS)
		addtimer(CALLBACK(fake, TYPE_PROC_REF(/datum, qdel_self)), 30 SECONDS)
		visible_message(span_notice("A weapon materializes from [src]!"))
	else
		return ..()

//Lovine Memory
/obj/item/ego_weapon/branch12/mini/loving_memory
	name = "loving memory"
	desc = "In Memory of that which you lost."
	icon_state = "nostalgia"
	force = 14
	throwforce = 33
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
