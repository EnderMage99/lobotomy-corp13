/obj/item/workshop_mod/toxic
	forcemod = 0.95

/obj/item/workshop_mod/toxic/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			H.Jitter(20)
			H.set_confusion(max(10, H.get_confusion()))

/obj/item/workshop_mod/toxic/red
	name = "toxic red damage mod"
	desc = "A workshop mod which changes the weapon to stun the foe and turns a weapon into red damage"
	modname = "heavy"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE


/obj/item/workshop_mod/toxic/white
	name = "toxic white damage mod"
	desc = "A workshop mod which changes the weapon to stun the foe and turns a weapon into white damage"
	modname = "zealous"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/toxic/black
	name = "toxic black damage mod"
	desc = "A workshop mod which changes the weapon to stun the foe and turns a weapon into black damage"
	color = "#442047"
	modname = "shady"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/toxic/pale
	name = "toxic pale damage mod"
	desc = "A workshop mod which changes the weapon to stun the foe and turns a weapon into pale damage"
	forcemod = 0.60
	color = "#80c8ff"
	modname = "personal"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
