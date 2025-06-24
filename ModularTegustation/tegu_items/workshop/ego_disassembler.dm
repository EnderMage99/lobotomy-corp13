/obj/item/weapon_shard
	name = "weapon shard"
	desc = "A strange shard extracted from weaponry."
	icon = 'icons/obj/shards.dmi'
	icon_state = "small"
	w_class = WEIGHT_CLASS_SMALL
	var/damage_type = RED_DAMAGE
	var/material_density = "normal"
	var/rarity = 0

/obj/item/weapon_shard/Initialize()
	. = ..()
	UpdateAppearance()

/obj/item/weapon_shard/proc/UpdateAppearance()
	var/type_name = "unknown"
	var/type_color = "#808080"

	switch(damage_type)
		if(RED_DAMAGE)
			type_name = "red"
			type_color = "#FF0000"
		if(WHITE_DAMAGE)
			type_name = "white"
			type_color = "#FFFFFF"
		if(BLACK_DAMAGE)
			type_name = "black"
			type_color = "#000000"
		if(PALE_DAMAGE)
			type_name = "pale"
			type_color = "#34b2dd"

	var/rarity_name = ""
	switch(rarity)
		if(0)
			rarity_name = "crude"
		if(1)
			rarity_name = "common"
		if(2)
			rarity_name = "refined"
		if(3)
			rarity_name = "exceptional"
		if(4 to INFINITY)
			rarity_name = "legendary"

	name = "[rarity_name] [material_density] [type_name] weapon shard"
	desc = "A [material_density] shard extracted from weaponry. It radiates [type_name] energy."
	color = type_color

	// Adjust size based on density
	switch(material_density)
		if("lightweight")
			transform = matrix(0.8, 0, 0, 0, 0.8, 0)
		if("heavy")
			transform = matrix(1.2, 0, 0, 0, 1.2, 0)

/obj/item/weapon_shard/examine(mob/user)
	. = ..()
	. += span_notice("Damage Type: [damage_type]")
	. += span_notice("Density: [material_density]")
	. += span_notice("Rarity: [rarity]")

/obj/structure/weaponry_disassembler
	name = "weaponry disassembler"
	desc = "A specialized machine that breaks down weaponry into their base materials. Use harm intent to activate."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "smoke0"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/list/loaded_weapons = list()
	var/processing = FALSE
	var/processing_time = 5 SECONDS

/obj/structure/weaponry_disassembler/examine(mob/user)
	. = ..()
	if(loaded_weapons.len)
		. += span_notice("Contains [loaded_weapons.len] weapon\s.")
		. += span_notice("Hit with harm intent to begin disassembly.")
	else
		. += span_notice("Load weaponry to begin disassembly.")

/obj/structure/weaponry_disassembler/attackby(obj/item/I, mob/living/user, params)
	if(processing)
		to_chat(user, span_warning("[src] is currently processing!"))
		return

	if(!istype(I, /obj/item/ego_weapon))
		to_chat(user, span_warning("[src] only accepts weaponry!"))
		return ..()

	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return

	loaded_weapons += I
	to_chat(user, span_notice("You load [I] into [src]. ([loaded_weapons.len] loaded)"))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)

/obj/structure/weaponry_disassembler/attack_hand(mob/living/user)
	if(user.a_intent != INTENT_HARM)
		to_chat(user, span_notice("Use harm intent to activate [src]."))
		return

	if(processing)
		to_chat(user, span_warning("[src] is already processing!"))
		return

	if(!loaded_weapons.len)
		to_chat(user, span_warning("[src] is empty!"))
		return

	StartProcessing(user)

/obj/structure/weaponry_disassembler/proc/StartProcessing(mob/user)
	processing = TRUE
	icon_state = "smoke1"
	visible_message(span_notice("[user] activates [src]."))
	playsound(src, 'sound/machines/blender.ogg', 50, TRUE)

	addtimer(CALLBACK(src, PROC_REF(FinishProcessing)), processing_time)

/obj/structure/weaponry_disassembler/proc/FinishProcessing()
	var/turf/T = get_turf(src)

	for(var/obj/item/ego_weapon/W in loaded_weapons)
		// Determine density based on attack speed
		var/material_density = "normal"
		if(W.attack_speed < 0.7)
			material_density = "lightweight"
		else if(W.attack_speed > 1.3)
			material_density = "heavy"

		// Calculate rarity from attribute requirements
		var/total_requirements = 0
		var/requirement_count = 0
		for(var/attr in W.attribute_requirements)
			if(W.attribute_requirements[attr] > 0)
				total_requirements += W.attribute_requirements[attr]
				requirement_count++

		var/average_requirement = 0
		if(requirement_count > 0)
			average_requirement = total_requirements / requirement_count

		var/material_rarity = round(average_requirement / 30)

		// Create multiple shards (4-7)
		var/shard_count = rand(4, 7)
		for(var/i = 1 to shard_count)
			var/obj/item/weapon_shard/M = new(T)
			M.damage_type = W.damtype
			M.material_density = material_density
			M.rarity = material_rarity
			M.UpdateAppearance()

		// Destroy the weapon
		qdel(W)

	loaded_weapons.Cut()
	processing = FALSE
	icon_state = "smoke0"

	visible_message(span_nicegreen("[src] has finished processing!"))
	playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
