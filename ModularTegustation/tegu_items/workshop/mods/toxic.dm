/obj/item/workshop_mod/toxic
	name = ""
	desc = ""
	forcemod = 0.95

/obj/item/workshop_mod/toxic/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			H.Jitter(20)
			H.set_confusion(max(10, H.get_confusion()))

