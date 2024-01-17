/*To finish
RefineCore - Increases weapon class to WAW.
Fullcore - Heals both HP and SP on hit, very slightly.
Rendcore - reduces target defense slightly*/

//Damage Color mods.
/obj/item/workshop_mod/regular
	icon_state = "blankcore"
	overlay = "regular"

/obj/item/workshop_mod/regular/red
	name = "basic red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "quality"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/regular/white
	name = "basic white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "sane"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE

/obj/item/workshop_mod/regular/black
	name = "basic black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "dark"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/regular/pale
	name = "basic pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "soul"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE


//Faster Speed mods
/obj/item/workshop_mod/fast
	icon_state = "blanklight"
	attackspeedmod = 0.7
	forcemod = 0.8
	overlay = "light"

/obj/item/workshop_mod/fast/red
	name = "fast red damage mod"
	desc = "A workshop mod to increase weapon speed and turn a weapon into red damage"
	modname = "quick"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE


/obj/item/workshop_mod/fast/white
	name = "fast white damage mod"
	desc = "A workshop mod to increase weapon speed and turn a weapon into white damage"
	modname = "zealous"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/fast/black
	name = "fast black damage mod"
	desc = "A workshop mod to increase weapon speed and turn a weapon into black damage"
	color = "#442047"
	modname = "shady"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/fast/pale
	name = "fast pale damage mod"
	desc = "A workshop mod to increase weapon speed and turn a weapon into pale damage"
	forcemod = 0.5
	color = "#80c8ff"
	modname = "personal"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE


//Slower Speed mods
/obj/item/workshop_mod/slow
	icon_state = "blankheavy"
	attackspeedmod = 1.5
	forcemod = 1.4
	overlay = "heavy"

/obj/item/workshop_mod/slow/red
	name = "heavy red damage mod"
	desc = "A workshop mod to increase weapon damage and turn a weapon into red damage"
	modname = "heavy"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE


/obj/item/workshop_mod/slow/white
	name = "heavy white damage mod"
	desc = "A workshop mod to increase weapon damage and turn a weapon into white damage"
	modname = "zealous"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE


/obj/item/workshop_mod/slow/black
	name = "heavy black damage mod"
	desc = "A workshop mod to increase weapon damage and turn a weapon into black damage"
	color = "#442047"
	modname = "shady"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE


/obj/item/workshop_mod/slow/pale
	name = "heavy pale damage mod"
	desc = "A workshop mod to increase weapon damage and turn a weapon into pale damage"
	forcemod = 1.1
	color = "#80c8ff"
	modname = "personal"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE

/obj/item/workshop_mod/draining
	name = ""
	desc = ""
	forcemod = 1.5

//Drains both physical and mental health.
/obj/item/workshop_mod/draining/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/drain_amt = T.force*0.05
		user.adjustBruteLoss(drain_amt)
		user.adjustSanityLoss(drain_amt)

// various drain mods go here .........

/obj/item/workshop_mod/superheavy
	name = ""
	desc = ""
	forcemod = 1.7
	attackspeedmod = 1.5

/obj/item/workshop_mod/superheavy/InstallationEffect(obj/item/ego_weapon/template/T)
	modded_temp = T
	T.slowdown += 1
	..()

// various superheavy mods go here .........

/obj/item/workshop_mod/blunt
	name = ""
	desc = ""
	forcemod = 0.75

/obj/item/workshop_mod/blunt/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			H.adjustStaminaLoss(T.force)

// various blunt mods go here .........


