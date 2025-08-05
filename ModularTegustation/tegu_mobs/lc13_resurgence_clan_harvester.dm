/mob/living/simple_animal/hostile/clan/harvester
	name = "Clan Harvester"
	desc = "A resource gathering unit with specialized extraction tools... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_citzen_1"
	icon_living = "clan_citzen_1"
	icon_dead = "clan_citzen_dead"
	health = 300
	maxHealth = 300
	damage_coeff = list(BRUTE = 1.2, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	attack_sound = 'sound/items/welder2.ogg'
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	melee_damage_lower = 3
	melee_damage_upper = 5
	robust_searching = TRUE
	stat_attack = CONSCIOUS
	vision_range = 5
	aggro_vision_range = 5
	move_to_delay = 4
	charge = 0
	max_charge = 0
	retreat_distance = 6
	minimum_distance = 5
	search_objects = 3
	wanted_objects = list(/obj/structure/metal_deposit)
	del_on_death = FALSE

	// Harvester specific vars
	var/carrying_metal = 0
	var/max_carry = 20
	var/harvest_time = 2 SECONDS
	var/harvesting = FALSE
	var/obj/structure/metal_deposit/current_deposit = null
	var/obj/structure/return_target = null // Factory or depot to return to

/mob/living/simple_animal/hostile/clan/harvester/examine(mob/user)
	. = ..()
	if(commander)
		. += span_notice("Controlled by [commander].")
	. += span_notice("Carrying: [carrying_metal]/[max_carry] metal")
	if(harvesting)
		. += span_notice("Currently harvesting...")

/mob/living/simple_animal/hostile/clan/harvester/Life()
	. = ..()
	if(!.)
		return

	// Auto-return when full
	if(carrying_metal >= max_carry && !return_target)
		FindReturnTarget()

	// Check if we're at a return target
	if(return_target && get_dist(src, return_target) <= 1)
		DeliverMetal()

/mob/living/simple_animal/hostile/clan/harvester/proc/FindReturnTarget()
	// Find nearest factory or depot
	var/obj/structure/closest_target = null
	var/min_distance = INFINITY

	if(commander)
		// Check factories
		for(var/obj/structure/clan_factory/F in commander.owned_factories)
			if(F.z != z)
				continue
			var/dist = get_dist(src, F)
			if(dist < min_distance)
				min_distance = dist
				closest_target = F

	// TODO: Add depot checking when depots are implemented

	if(closest_target)
		return_target = closest_target
		order_target = get_turf(return_target)
		LoseTarget()
		Goto(order_target, move_to_delay, 0)

/mob/living/simple_animal/hostile/clan/harvester/proc/DeliverMetal()
	if(!return_target || !carrying_metal)
		return

	// Deliver to commander via factory/depot
	if(commander && carrying_metal > 0)
		var/delivered = commander.ReceiveMetal(carrying_metal)
		if(delivered > 0)
			visible_message(span_notice("[src] delivers [delivered] metal!"))
			carrying_metal = 0

	return_target = null
	order_target = null

	// Go back to finding deposits
	if(!current_deposit || QDELETED(current_deposit))
		FindNewDeposit()

/mob/living/simple_animal/hostile/clan/harvester/proc/FindNewDeposit()
	// Look for metal deposits
	var/obj/structure/metal_deposit/best_deposit = null
	var/min_distance = INFINITY

	for(var/obj/structure/metal_deposit/M in oview(vision_range, src))
		if(M.metal_amount <= 0)
			continue
		var/dist = get_dist(src, M)
		if(dist < min_distance)
			min_distance = dist
			best_deposit = M

	if(best_deposit)
		current_deposit = best_deposit
		GiveTarget(best_deposit)

/mob/living/simple_animal/hostile/clan/harvester/AttackingTarget(atom/attacked_target)
	if(!attacked_target)
		attacked_target = target

	// Check if we're attacking a metal deposit
	if(istype(attacked_target, /obj/structure/metal_deposit))
		var/obj/structure/metal_deposit/M = attacked_target
		StartHarvesting(M)
		return

	// Otherwise do normal attack
	return ..()

/mob/living/simple_animal/hostile/clan/harvester/proc/StartHarvesting(obj/structure/metal_deposit/deposit)
	if(harvesting || !deposit || deposit.metal_amount <= 0)
		return

	if(carrying_metal >= max_carry)
		FindReturnTarget()
		return

	harvesting = TRUE
	current_deposit = deposit
	visible_message(span_notice("[src] begins harvesting metal from [deposit]..."))
	playsound(src, 'sound/items/welder.ogg', 50, TRUE)

	if(do_after(src, harvest_time, target = deposit))
		HarvestMetal(deposit)
	else
		harvesting = FALSE

/mob/living/simple_animal/hostile/clan/harvester/proc/HarvestMetal(obj/structure/metal_deposit/deposit)
	harvesting = FALSE

	if(!deposit || deposit.metal_amount <= 0 || carrying_metal >= max_carry)
		return

	var/harvest_amount = min(max_carry - carrying_metal, 10, deposit.metal_amount)
	carrying_metal += harvest_amount
	deposit.metal_amount -= harvest_amount

	playsound(src, 'sound/items/crowbar.ogg', 50, TRUE)
	visible_message(span_notice("[src] extracts [harvest_amount] metal! ([carrying_metal]/[max_carry])"))

	// Update deposit appearance
	deposit.UpdateAppearance()

	// Check if we should return or continue harvesting
	if(carrying_metal >= max_carry)
		FindReturnTarget()
	else if(deposit.metal_amount > 0)
		StartHarvesting(deposit)
	else
		current_deposit = null
		FindNewDeposit()

/mob/living/simple_animal/hostile/clan/harvester/death(gibbed)
	// Drop carried metal
	if(carrying_metal > 0)
		new /obj/item/stack/sheet/metal(get_turf(src), carrying_metal)
		visible_message(span_notice("[src] drops [carrying_metal] metal!"))

	if(commander)
		commander.harvester_units -= src

	return ..()

/mob/living/simple_animal/hostile/clan/harvester/Destroy()
	if(commander)
		commander.harvester_units -= src
	return ..()
