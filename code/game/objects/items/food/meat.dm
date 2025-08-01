//Not only meat, actually, but also snacks that are almost meat, such as fish meat or tofu


////////////////////////////////////////////FISH////////////////////////////////////////////

/obj/item/food/cubancarp
	name = "\improper Cuban carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash_type = /obj/item/trash/plate
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6,  /datum/reagent/consumable/capsaicin = 1, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("fish" = 4, "batter" = 1, "hot peppers" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat."
	icon_state = "fishfillet"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin/carpotoxin = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 6
	tastes = list("fish" = 1)
	foodtypes = MEAT
	eatverbs = list("bite","chew","gnaw","swallow","chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/carpmeat/Initialize()
	. = ..()
	if(!istype(src, /obj/item/food/carpmeat/imitation))
		AddElement(/datum/element/swabable, CELL_LINE_TABLE_CARP, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/carpmeat/imitation
	name = "imitation carp fillet"
	desc = "Almost just like the real thing, kinda."

/obj/item/food/carpmeat/icantbeliveitsnotcarp
	name = "fish fillet"
	desc = "A fillet of unspecified fish meat."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2) //No carpotoxin

/obj/item/food/carpmeat/icantbeliveitsnotcarp/Initialize()
	. = ..()
	AddComponent(/datum/component/grillable, /obj/item/food/carpmeat/icantbeliveitsnotcarp, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/fishandchips
	name = "fish and chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("fish" = 1, "chips" = 1)
	foodtypes = MEAT | VEGETABLES | FRIED

////////////////////////////////////////////MEATS AND ALIKE////////////////////////////////////////////

/obj/item/food/tofu
	name = "tofu"
	desc = "We all love tofu."
	icon_state = "tofu"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("tofu" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tofu/prison
	name = "soggy tofu"
	desc = "You refuse to eat this strange bean curd."
	tastes = list("sour, rotten water" = 1)
	foodtypes = GROSS

/obj/item/food/spiderleg
	name = "spider leg"
	desc = "A still twitching leg of a giant spider... you don't really want to eat this, do you?"
	icon_state = "spiderleg"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/toxin = 2)
	tastes = list("cobwebs" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spiderleg/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/boiledspiderleg, rand(50 SECONDS, 60 SECONDS), TRUE, TRUE)

/obj/item/food/cornedbeef
	name = "corned beef and cabbage"
	desc = "Now you can feel like a real tourist vacationing in Ireland."
	icon_state = "cornedbeef"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("meat" = 1, "cabbage" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/bearsteak
	name = "Filet migrawr"
	desc = "Because eating bear wasn't manly enough."
	icon_state = "bearsteak"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 9, /datum/reagent/consumable/ethanol/manly_dorf = 5)
	tastes = list("meat" = 1, "salmon" = 1)
	foodtypes = MEAT | ALCOHOL
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_meatball
	name = "raw meatball"
	desc = "A great meal all round. Not a cord of wood. Kinda raw"
	icon_state = "raw_meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/meatball_type = /obj/item/food/meatball
	var/patty_type = /obj/item/food/raw_patty

/obj/item/food/raw_meatball/MakeGrillable()
	AddComponent(/datum/component/grillable, meatball_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_meatball/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, patty_type, 1, 20)
/obj/item/food/raw_meatball/human
	name = "strange raw meatball"
	meatball_type = /obj/item/food/meatball/human
	patty_type = /obj/item/food/raw_patty/human

/obj/item/food/raw_meatball/corgi
	name = "raw corgi meatball"
	meatball_type = /obj/item/food/meatball/corgi
	patty_type = /obj/item/food/raw_patty/corgi

/obj/item/food/raw_meatball/xeno
	name = "raw xeno meatball"
	meatball_type = /obj/item/food/meatball/xeno
	patty_type = /obj/item/food/raw_patty/xeno

/obj/item/food/raw_meatball/bear
	name = "raw bear meatball"
	meatball_type = /obj/item/food/meatball/bear
	patty_type = /obj/item/food/raw_patty/bear

/obj/item/food/raw_meatball/chicken
	name = "raw chicken meatball"
	meatball_type = /obj/item/food/meatball/chicken
	patty_type = /obj/item/food/raw_patty/chicken

/obj/item/food/meatball
	name = "meatball"
	desc = "A great meal all round. Not a cord of wood."
	icon_state = "meatball"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/meatball/human
	name = "strange meatball"

/obj/item/food/meatball/corgi
	name = "corgi meatball"

/obj/item/food/meatball/bear
	name = "bear meatball"
	tastes = list("meat" = 1, "salmon" = 1)

/obj/item/food/meatball/xeno
	name = "xenomorph meatball"
	tastes = list("meat" = 1, "acid" = 1)

/obj/item/food/meatball/chicken
	name = "chicken meatball"
	tastes = list("chicken" = 1)
	icon_state = "chicken_meatball"

/obj/item/food/raw_patty
	name = "raw patty"
	desc = "I'm.....NOT REAAADDYY."
	icon_state = "raw_patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	var/patty_type = /obj/item/food/patty/plain

/obj/item/food/raw_patty/MakeGrillable()
	AddComponent(/datum/component/grillable, patty_type, rand(30 SECONDS, 40 SECONDS), TRUE)

/obj/item/food/raw_patty/human
	name = "strange raw patty"
	patty_type = /obj/item/food/patty/human

/obj/item/food/raw_patty/corgi
	name = "raw corgi patty"
	patty_type = /obj/item/food/patty/corgi

/obj/item/food/raw_patty/bear
	name = "raw bear patty"
	tastes = list("meat" = 1, "salmon" = 1)
	patty_type = /obj/item/food/patty/bear

/obj/item/food/raw_patty/xeno
	name = "raw xenomorph patty"
	tastes = list("meat" = 1, "acid" = 1)
	patty_type = /obj/item/food/patty/xeno

/obj/item/food/raw_patty/chicken
	name = "raw chicken patty"
	tastes = list("chicken" = 1)
	patty_type = /obj/item/food/patty/chicken

/obj/item/food/patty
	name = "patty"
	desc = "The nanotrasen patty is the patty for you and me!"
	icon_state = "patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

///Exists purely for the crafting recipe (because itll take subtypes)
/obj/item/food/patty/plain

/obj/item/food/patty/human
	name = "strange patty"

/obj/item/food/patty/corgi
	name = "corgi patty"

/obj/item/food/patty/bear
	name = "bear patty"
	tastes = list("meat" = 1, "salmon" = 1)

/obj/item/food/patty/xeno
	name = "xenomorph patty"
	tastes = list("meat" = 1, "acid" = 1)

/obj/item/food/patty/chicken
	name = "chicken patty"
	tastes = list("chicken" = 1)
	icon_state = "chicken_patty"

/obj/item/food/raw_sausage
	name = "raw sausage"
	desc = "A piece of mixed, long meat, but then raw"
	icon_state = "raw_sausage"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT | RAW
	eatverbs = list("bite","chew","nibble","deep throat","gobble","chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/raw_sausage/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/sausage, rand(60 SECONDS, 75 SECONDS), TRUE)

/obj/item/food/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT | BREAKFAST
	eatverbs = list("bite","chew","nibble","deep throat","gobble","chomp")
	var/roasted = FALSE
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/sausage/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/salami, 6, 30)
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/american_sausage, 1, 30)

/obj/item/food/american_sausage
	name = "american sausage"
	desc = "Snip."
	icon_state = "american_sausage"

/obj/item/food/salami
	name = "salami"
	desc = "A slice of cured salami."
	icon_state = "salami"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("meat" = 1, "smoke" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawkhinkali
	name = "raw khinkali"
	desc = "One hundred khinkalis? Do I look like a pig?"
	icon_state = "khinkali"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/garlic = 1)
	tastes = list("meat" = 1, "onions" = 1, "garlic" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/rawkhinkali/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/khinkali, rand(50 SECONDS, 60 SECONDS), TRUE)

/obj/item/food/khinkali
	name = "khinkali"
	desc = "One hundred khinkalis? Do I look like a pig?"
	icon_state = "khinkali"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/garlic = 1)
	bite_consumption = 3
	tastes = list("meat" = 1, "onions" = 1, "garlic" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bite_consumption = 12
	food_reagents = list(/datum/reagent/monkey_powder = 30)
	tastes = list("the jungle" = 1, "bananas" = 1)
	foodtypes = MEAT | SUGAR
	w_class = WEIGHT_CLASS_TINY
	var/faction
	var/spawned_mob = /mob/living/carbon/human/species/monkey

/obj/item/food/monkeycube/proc/Expand()
	var/mob/spammer = get_mob_by_key(fingerprintslast)
	var/mob/living/bananas = new spawned_mob(drop_location(), TRUE, spammer)
	if(faction)
		bananas.faction = faction
	if (!QDELETED(bananas))
		visible_message(span_notice("[src] expands!"))
		bananas.log_message("Spawned via [src] at [AREACOORD(src)], Last attached mob: [key_name(spammer)].", LOG_ATTACK)
	else if (!spammer) // Visible message in case there are no fingerprints
		visible_message(span_notice("[src] fails to expand!"))
	qdel(src)

/obj/item/food/monkeycube/suicide_act(mob/living/M)
	M.visible_message(span_suicide("[M] is putting [src] in [M.p_their()] mouth! It looks like [M.p_theyre()] trying to commit suicide!"))
	var/eating_success = do_after(M, 1 SECONDS, src)
	if(QDELETED(M)) //qdeletion: the nuclear option of self-harm
		return SHAME
	if(!eating_success || QDELETED(src)) //checks if src is gone or if they failed to wait for a second
		M.visible_message(span_suicide("[M] chickens out!"))
		return SHAME
	if(HAS_TRAIT(M, TRAIT_NOHUNGER)) //plasmamen don't have saliva/stomach acid
		M.visible_message(span_suicide("[M] realizes [M.p_their()] body won't activate [src]!")
		,span_warning("Your body won't activate [src]..."))
		return SHAME
	playsound(M, 'sound/items/eatfood.ogg', rand(10,50), TRUE)
	M.temporarilyRemoveItemFromInventory(src) //removes from hands, keeps in M
	addtimer(CALLBACK(src, PROC_REF(finish_suicide), M), 15) //you've eaten it, you can run now
	return MANUAL_SUICIDE

/obj/item/food/monkeycube/proc/finish_suicide(mob/living/M) ///internal proc called by a monkeycube's suicide_act using a timer and callback. takes as argument the mob/living who activated the suicide
	if(QDELETED(M) || QDELETED(src))
		return
	if((src.loc != M)) //how the hell did you manage this
		to_chat(M, span_warning("Something happened to [src]..."))
		return
	Expand()
	M.visible_message(span_danger("[M]'s torso bursts open as a primate emerges!"))
	M.gib(null, TRUE, null, TRUE)

/obj/item/food/monkeycube/syndicate
	faction = list("neutral", ROLE_SYNDICATE)

/obj/item/food/monkeycube/gorilla
	name = "gorilla cube"
	desc = "A Waffle Co. brand gorilla cube. Now with extra molecules!"
	bite_consumption = 20
	food_reagents = list(/datum/reagent/monkey_powder = 30, /datum/reagent/medicine/strange_reagent = 5)
	tastes = list("the jungle" = 1, "bananas" = 1, "jimmies" = 1)
	spawned_mob = /mob/living/simple_animal/hostile/gorilla

/obj/item/food/enchiladas
	name = "enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	bite_consumption = 4
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/capsaicin = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("hot peppers" = 1, "meat" = 3, "cheese" = 1, "sour cream" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("soy" = 1, "vegetables" = 1)
	eatverbs = list("slurp","sip","inhale","drink")
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/stewedsoymeat/Initialize()
	. = ..()

/obj/item/food/boiledspiderleg
	name = "boiled spider leg"
	desc = "A giant spider's leg that's still twitching after being cooked. Gross!"
	icon_state = "spiderlegcooked"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/capsaicin = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("hot peppers" = 1, "cobwebs" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	burns_on_grill = TRUE

/obj/item/food/spidereggsham
	name = "green eggs and ham"
	desc = "Would you eat them on a train? Would you eat them on a plane? Would you eat them on a state of the art corporate deathtrap floating through space?"
	icon_state = "spidereggsham"
	trash_type = /obj/item/trash/plate
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 3)
	bite_consumption = 4
	tastes = list("meat" = 1, "the colour green" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/nugget
	name = "chicken nugget"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("\"chicken\"" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/nugget/Initialize()
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "A 'chicken' nugget vaguely shaped like a [shape]."
	icon_state = "nugget_[shape]"

/obj/item/food/pigblanket
	name = "pig in a blanket"
	desc = "A tiny sausage wrapped in a flakey, buttery roll. Free this pig from its blanket prison by eating it."
	icon_state = "pigblanket"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("meat" = 1, "butter" = 1)
	foodtypes = MEAT | DAIRY
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/bbqribs
	name = "bbq ribs"
	desc = "BBQ ribs, slathered in a healthy coating of BBQ sauce. The least vegan thing to ever exist."
	icon_state = "ribs"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/consumable/bbqsauce = 10)
	tastes = list("meat" = 3, "smokey sauce" = 1)
	foodtypes = MEAT

/obj/item/food/meatclown
	name = "meat clown"
	desc = "A delicious, round piece of meat clown. How horrifying."
	icon_state = "meatclown"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/banana = 2)
	tastes = list("meat" = 5, "clowns" = 3, "sixteen teslas" = 1)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/meatclown/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 30)

/obj/item/food/lasagna
	name = "Lasagna"
	desc = "A slice of lasagna. Perfect for a Monday afternoon."
	icon_state = "lasagna"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/tomatojuice = 10)
	tastes = list("meat" = 3, "pasta" = 3, "tomato" = 2, "cheese" = 2)
	foodtypes = MEAT | DAIRY | GRAIN

/obj/item/food/yukhoe
	name = "Yukhoe"
	desc = "Korean tartare, basically."
	icon_state = "yukhoe"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/eggyolk = 4)
	tastes = list("meat" = 2, "egg yolk" = 3)
	foodtypes = MEAT

/obj/item/food/meatjam
	name = "meat jam"
	desc = "A jar of delicious meat jam."
	icon_state = "meatproduct" //this is a placeholder
	food_reagents = list(/datum/reagent/consumable/nutriment/protein =  5, /datum/reagent/abnormality/we_can_change_anything = 3)
	tastes = list("strange meat" = 3, "suffering" = 1)
	foodtypes = MEAT


//////////////////////////////////////////// KEBABS AND OTHER SKEWERS ////////////////////////////////////////////

/obj/item/food/kebab
	trash_type = /obj/item/stack/rods
	icon_state = "kebab"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 14)
	tastes = list("meat" = 3, "metal" = 1)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/kebab/human
	name = "human-kebab"
	desc = "A human meat, on a stick."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("tender meat" = 3, "metal" = 1)
	foodtypes = MEAT | GROSS

/obj/item/food/kebab/monkey
	name = "meat-kebab"
	desc = "Delicious meat, on a stick."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("meat" = 3, "metal" = 1)
	foodtypes = MEAT

/obj/item/food/kebab/tofu
	name = "tofu-kebab"
	desc = "Vegan meat, on a stick."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 15)
	tastes = list("tofu" = 3, "metal" = 1)
	foodtypes = VEGETABLES

/obj/item/food/kebab/tail
	name = "lizard-tail kebab"
	desc = "Severed lizard tail on a stick."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 30, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("meat" = 8, "metal" = 4, "scales" = 1)
	foodtypes = MEAT

/obj/item/food/kebab/rat
	name = "rat-kebab"
	desc = "Not so delicious rat meat, on a stick."
	icon_state = "ratkebab"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("rat meat" = 1, "metal" = 1)
	foodtypes = MEAT | GROSS

/obj/item/food/kebab/rat/double
	name = "double rat-kebab"
	icon_state = "doubleratkebab"
	tastes = list("rat meat" = 2, "metal" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/consumable/nutriment/vitamin = 6)

/obj/item/food/kebab/fiesta
	name = "fiesta skewer"
	icon_state = "fiestaskewer"
	tastes = list("tex-mex" = 3, "cumin" = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 12, /datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/consumable/capsaicin = 3)

/obj/item/food/meat
	custom_materials = list(/datum/material/meat = MINERAL_MATERIAL_AMOUNT * 4)
	material_flags = MATERIAL_NO_EFFECTS
	var/subjectname = ""
	var/subjectjob = null
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/meat/slab
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/cooking_oil = 2) //Meat has fats that a food processor can process into cooking oil
	tastes = list("meat" = 1)
	foodtypes = MEAT | RAW
	///Legacy code, handles the coloring of the overlay of the cutlets made from this.
	var/slab_color = "#FF0000"

/obj/item/food/meat/slab/Initialize()
	. = ..()
	AddElement(/datum/element/dryable,  /obj/item/food/sosjerky/healthy)

/obj/item/food/meat/slab/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain, 3, 30)

///////////////////////////////////// HUMAN MEATS //////////////////////////////////////////////////////

/obj/item/food/meat/slab/human
	name = "meat"
	tastes = list("tender meat" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/slab/human/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/plain/human, 3, 30)

/obj/item/food/meat/slab/human/mutant/slime
	icon_state = "slimemeat"
	desc = "Because jello wasn't offensive enough to vegans."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin/slimejelly = 3)
	tastes = list("slime" = 1, "jelly" = 1)
	foodtypes = MEAT | RAW | TOXIC

/obj/item/food/meat/slab/human/mutant/golem
	icon_state = "golemmeat"
	desc = "Edible rocks, welcome to the future."
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/iron = 3)
	tastes = list("rock" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/golem/adamantine
	icon_state = "agolemmeat"
	desc = "From the slime pen to the rune to the kitchen, science."
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/lizard
	icon_state = "lizardmeat"
	desc = "Delicious dino damage."
	tastes = list("meat" = 4, "scales" = 1)
	foodtypes = MEAT | RAW

/obj/item/food/meat/slab/human/mutant/lizard/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/plain/human/lizard, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/human/mutant/plant
	icon_state = "plantmeat"
	desc = "All the joys of healthy eating with all the fun of cannibalism."
	tastes = list("salad" = 1, "wood" = 1)
	foodtypes = VEGETABLES

/obj/item/food/meat/slab/human/mutant/shadow
	icon_state = "shadowmeat"
	desc = "Ow, the edge."
	tastes = list("darkness" = 1, "meat" = 1)
	foodtypes = MEAT | RAW

/obj/item/food/meat/slab/human/mutant/fly
	icon_state = "flymeat"
	desc = "Nothing says tasty like maggot filled radioactive mutant flesh."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/uranium = 3)
	tastes = list("maggots" = 1, "the inside of a reactor" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/human/mutant/moth
	name = "bug meat"
	icon_state = "mothmeat"
	desc = "Unpleasantly powdery and dry. Kind of pretty, though."
	tastes = list("dust" = 1, "powder" = 1, "meat" = 2)
	foodtypes = MEAT | RAW

/obj/item/food/meat/slab/human/mutant/skeleton
	name = "bone"
	icon_state = "skeletonmeat"
	desc = "There's a point where this needs to stop, and clearly we have passed it."
	tastes = list("bone" = 1)
	foodtypes = GROSS

/obj/item/food/meat/slab/human/mutant/skeleton/MakeProcessable()
	return //skeletons dont have cutlets

/obj/item/food/meat/slab/human/mutant/zombie
	name = " meat (rotten)"
	icon_state = "rottenmeat"
	desc = "Halfway to becoming fertilizer for your garden."
	food_reagents = list(/datum/reagent/consumable/nutriment/vile_fluid = 6)
	tastes = list("brains" = 1, "meat" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/human/mutant/ethereal
	icon_state = "etherealmeat"
	desc = "So shiny you feel like ingesting it might make you shine too"
	food_reagents = list(/datum/reagent/consumable/liquidelectricity = 3)
	tastes = list("pure electricity" = 2, "meat" = 1)
	foodtypes = RAW | MEAT | TOXIC

////////////////////////////////////// OTHER MEATS ////////////////////////////////////////////////////////


/obj/item/food/meat/slab/synthmeat
	name = "synthmeat"
	icon_state = "meat_old"
	desc = "A synthetic slab of meat."
	foodtypes = RAW | MEAT //hurr durr chemicals we're harmed in the production of this meat thus its non-vegan.

/obj/item/food/meat/slab/synthmeat/MakeGrillable()
	AddComponent(/datum/component/grillable,/obj/item/food/meat/steak/plain/synth, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)
/obj/item/food/meat/slab/meatproduct
	name = "meat product"
	icon_state = "meatproduct"
	desc = "A slab of station reclaimed and chemically processed meat product."
	tastes = list("meat flavoring" = 2, "modified starches" = 2, "natural & artificial dyes" = 1, "butyric acid" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/meatproduct/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/monkey
	name = "monkey meat"
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/mouse
	name = "mouse meat"
	desc = "A slab of mouse meat. Best not eat it raw."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/mouse/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOUSE, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/corgi
	name = "corgi meat"
	desc = "Tastes like... well you know..."
	tastes = list("meat" = 4, "a fondness for wearing hats" = 1)
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/corgi/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CORGI, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/pug
	name = "pug meat"
	desc = "Tastes like... well you know..."
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/pug/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_PUG, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/killertomato
	name = "killer tomato meat"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	tastes = list("tomato" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/slab/killertomato/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/killertomato, rand(70 SECONDS, 85 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/killertomato/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/killertomato, 3, 30)

/obj/item/food/meat/slab/bear
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 16, /datum/reagent/medicine/morphine = 5, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/cooking_oil = 6)
	tastes = list("meat" = 1, "salmon" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/bear/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/bear, 3, 30)

/obj/item/food/meat/slab/bear/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/bear, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/bear/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/xeno
	name = "xeno meat"
	desc = "A slab of meat."
	icon_state = "xenomeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 3)
	bite_consumption = 4
	tastes = list("meat" = 1, "acid" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/xeno/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/xeno, 3, 30)

/obj/item/food/meat/slab/xeno/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/xeno, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/spider
	name = "spider meat"
	desc = "A slab of spider meat. That is so Kafkaesque."
	icon_state = "spidermeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/toxin = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cobwebs" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/spider/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/spider, 3, 30)

/obj/item/food/meat/slab/spider/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/spider, rand(40 SECONDS, 70 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/goliath
	name = "goliath meat"
	desc = "A slab of goliath meat. It's not very edible now, but it cooks great in lava."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/toxin = 5, /datum/reagent/consumable/cooking_oil = 3)
	icon_state = "goliathmeat"
	tastes = list("meat" = 1)
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/goliath/burn()
	visible_message(span_notice("[src] finishes cooking!"))
	new /obj/item/food/meat/steak/goliath(loc)
	qdel(src)

/obj/item/food/meat/slab/meatwheat
	name = "meatwheat clump"
	desc = "This doesn't look like meat, but your standards aren't <i>that</i> high to begin with."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/blood = 5, /datum/reagent/consumable/cooking_oil = 1)
	icon_state = "meatwheat_clump"
	bite_consumption = 4
	tastes = list("meat" = 1, "wheat" = 1)
	foodtypes = GRAIN

/obj/item/food/meat/slab/gorilla
	name = "gorilla meat"
	desc = "Much meatier than monkey meat."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/cooking_oil = 5) //Plenty of fat!

/obj/item/food/meat/rawbacon
	name = "raw piece of bacon"
	desc = "A raw piece of bacon."
	icon_state = "bacon"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("bacon" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/rawbacon/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/bacon, rand(25 SECONDS, 45 SECONDS), TRUE, TRUE)

/obj/item/food/meat/bacon
	name = "piece of bacon"
	desc = "A delicious piece of bacon."
	icon_state = "baconcooked"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("bacon" = 1)
	foodtypes = MEAT | BREAKFAST
	burns_on_grill = TRUE

/obj/item/food/meat/slab/gondola
	name = "gondola meat"
	desc = "According to legends of old, consuming raw gondola flesh grants one inner peace."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/tranquility = 5, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("meat" = 4, "tranquility" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/gondola/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/gondola, 3, 30)

/obj/item/food/meat/slab/gondola/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/gondola, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?


/obj/item/food/meat/slab/penguin
	name = "penguin meat"
	icon_state = "birdmeat"
	desc = "A slab of penguin meat."
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("beef" = 1, "cod fish" = 1)

/obj/item/food/meat/slab/gondola/MakeProcessable()
	. = ..()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/gondola, 3, 30)

/obj/item/food/meat/slab/penguin/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/penguin, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/rawcrab
	name = "raw crab meat"
	desc = "A pile of raw crab meat."
	icon_state = "crabmeatraw"
	microwaved_type = /obj/item/food/meat/crab
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 3, /datum/reagent/consumable/cooking_oil = 3)
	tastes = list("raw crab" = 1)
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/rawcrab/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/crab, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe?

/obj/item/food/meat/crab
	name = "crab meat"
	desc = "Some deliciously cooked crab meat."
	icon_state = "crabmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/cooking_oil = 2)
	tastes = list("crab" = 1)
	foodtypes = MEAT
	burns_on_grill = TRUE

/obj/item/food/meat/slab/chicken
	name = "chicken meat"
	icon_state = "birdmeat"
	desc = "A slab of raw chicken. Remember to wash your hands!"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6) //low fat
	tastes = list("chicken" = 1)

/obj/item/food/meat/slab/chicken/MakeProcessable()
	. = ..()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/meat/rawcutlet/chicken, 3, 30)

/obj/item/food/meat/slab/chicken/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/chicken, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) //Add medium rare later maybe? (no this is chicken)

/obj/item/food/meat/slab/chicken/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/slab/sweeper
	name = "meat slurry"
	desc = "Cobalt metal holding the liquified remains of a human, it smells rancid. It has the taste and texture of Surströmming."
	icon_state = "sweepermeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4)
	tastes = list("tender meat" = 1, "metal" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/fruit
	name = "curious meat"
	desc = "Wretched rubbery meat cut from a gigantic heart. It tastes of anxiety and has the texture of uncooked squid."
	icon_state = "fruitmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/consumable/sugar = 3)
	tastes = list("tender meat" = 1, "jelly" = 1, "slime" = 1)
	foodtypes = MEAT | RAW | TOXIC | JUNKFOOD

/obj/item/food/meat/slab/fruit/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/violet, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/worm
	name = "perfect meat"
	desc = "An awful jiggling chunk of meat cut from the hide of a worm. It tastes foul and has the texture of spoiled jelly."
	icon_state = "wormmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/yuck = 5, /datum/reagent/amber = 5)
	tastes = list("slime" = 1, "jelly" = 1)
	foodtypes = MEAT | RAW | TOXIC | GROSS

/obj/item/food/meat/slab/worm/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/amber, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/robot
	name = "nihilist component"
	desc = "Ancient metal, filaments and cogwheels, all absolutely ruined. It tastes of metal and has the texture of metal. Its metal."
	icon_state = "robotmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/iron = 3)
	tastes = list("metal" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/crimson
	name = "sweet meat"
	desc = "Scraped together from what was left, the result smells sickly sweet. You should eat this as fast as possible, as it looks to be going bad very soon."
	icon_state = "clownmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4)
	tastes = list("sugar" = 1, "nearly rotten flesh" = 1)
	foodtypes = MEAT | RAW | TOXIC | GROSS


/obj/item/food/meat/slab/crimson/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/crimson, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/buggy
	name = "buggy meat"
	desc = "A chunk of horrible and unpalatable mutated meat and chitin. Some bits are still moving..."
	icon_state = "buggymeat"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4)
	tastes = list("tender meat" = 1, "gristle" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/buggy/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) // too lazy to add a new sprite

/obj/item/food/meat/slab/corroded
	name = "corroded meat"
	desc = "Human meat, with other stuff mixed in. Hardly has any resemblance to the original anymore."
	icon_state = "xenomeat" // Placeholder
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4)
	tastes = list("tough meat" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/corroded/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) // too lazy to add a new sprite

/obj/item/food/meat/slab/sinnew
	name = "sin-eew"
	desc = "Eyeballs, veins, and offal that came from something no longer resembling a human."
	icon_state = "sinnew"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("blood" = 1, "tough meat" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/slab/sinnew/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/meatproduct, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE) // too lazy to add a new sprite

////////////////////////////////////// MEAT STEAKS ///////////////////////////////////////////////////////////

/obj/item/food/meat/steak
	name = "steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatsteak"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 8, /datum/reagent/consumable/nutriment/vitamin = 1)
	trash_type = /obj/item/trash/plate
	foodtypes = MEAT
	tastes = list("meat" = 1)
	burns_on_grill = TRUE

/obj/item/food/meat/steak/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(OnMicrowaveCooked))


/obj/item/food/meat/steak/proc/OnMicrowaveCooked(datum/source, obj/item/source_item, cooking_efficiency = 1)
	SIGNAL_HANDLER
	name = "[source_item.name] steak"

/obj/item/food/meat/steak/plain
	foodtypes = MEAT

/obj/item/food/meat/steak/plain/human
	tastes = list("tender meat" = 1)
	foodtypes = MEAT | GROSS

///Make sure the steak has the correct name
/obj/item/food/meat/steak/plain/human/OnMicrowaveCooked(datum/source, obj/item/source_item, cooking_efficiency = 1)
	. = ..()
	if(istype(source_item, /obj/item/food/meat))
		var/obj/item/food/meat/origin_meat = source_item
		subjectname = origin_meat.subjectname
		subjectjob = origin_meat.subjectjob
		if(subjectname)
			name = "[origin_meat.subjectname] meatsteak"
		else if(subjectjob)
			name = "[origin_meat.subjectjob] meatsteak"


/obj/item/food/meat/steak/killertomato
	name = "killer tomato steak"
	tastes = list("tomato" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/steak/bear
	name = "bear steak"
	tastes = list("meat" = 1, "salmon" = 1)

/obj/item/food/meat/steak/xeno
	name = "xeno steak"
	tastes = list("meat" = 1, "acid" = 1)

/obj/item/food/meat/steak/spider
	name = "spider steak"
	tastes = list("cobwebs" = 1)

/obj/item/food/meat/steak/goliath
	name = "goliath steak"
	desc = "A delicious, lava cooked steak."
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	icon_state = "goliathsteak"
	trash_type = null
	tastes = list("meat" = 1, "rock" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/gondola
	name = "gondola steak"
	tastes = list("meat" = 1, "tranquility" = 1)

/obj/item/food/meat/steak/penguin
	name = "penguin steak"
	icon_state = "birdsteak"
	tastes = list("beef" = 1, "cod fish" = 1)

/obj/item/food/meat/steak/chicken
	name = "chicken steak" //Can you have chicken steaks? Maybe this should be renamed once it gets new sprites.
	icon_state = "birdsteak"
	tastes = list("chicken" = 1)

/obj/item/food/meat/steak/plain/human/lizard
	name = "lizard steak"
	icon_state = "birdsteak"
	tastes = list("juicy chicken" = 3, "scales" = 1)
	foodtypes = MEAT

/obj/item/food/meat/steak/meatproduct
	name = "thermally processed meat product"
	icon_state = "meatproductsteak"
	tastes = list("enhanced char" = 2, "suspicious tenderness" = 2, "natural & artificial dyes" = 2, "emulsifying agents" = 1)

/obj/item/food/meat/steak/plain/synth
	name = "synthsteak"
	desc = "A synthetic meat steak. It doesn't look quite right, now does it?"
	icon_state = "meatsteak_old"
	tastes = list("meat" = 4, "cryoxandone" = 1)

/obj/item/food/meat/steak/violet
	name = "violet steak"
	desc = "The most edible part of the violet ordeals, cooking it seems to have removed the glyphs."
	icon_state = "violetsteak"
	tastes = list("squid" = 1, "half organic" = 1, "half inorganic" = 1, "love" = 1, "rocks" = 1)

/obj/item/food/meat/steak/amber
	name = "amber steak"
	desc = "Preparing the amber meat expresses the sophistication and control that the amber worms lacked."
	icon_state = "ambersteak"
	tastes = list("crab" = 1, "crunchy" = 1, "status quo" = 1)

/obj/item/food/meat/steak/crimson
	name = "crimson steak"
	desc = "Scraping together most of what you could, this meat is very sweet, but won't last much longer.."
	tastes = list("squid" = 1, "half organic" = 1, "half inorganic" = 1, "love" = 1)
	foodtypes = MEAT


//////////////////////////////// MEAT CUTLETS ///////////////////////////////////////////////////////

//Raw cutlets

/obj/item/food/meat/rawcutlet
	name = "raw cutlet"
	desc = "A raw meat cutlet."
	icon_state = "rawcutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT | RAW
	var/meat_type = "meat"

/obj/item/food/meat/rawcutlet/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/OnCreatedFromProcessing(mob/living/user, obj/item/I, list/chosen_option, atom/original_atom)
	..()
	if(istype(original_atom, /obj/item/food/meat/slab))
		var/obj/item/food/meat/slab/original_slab = original_atom
		var/mutable_appearance/filling = mutable_appearance(icon, "rawcutlet_coloration")
		filling.color = original_slab.slab_color
		add_overlay(filling)
		name = "raw [original_atom.name] cutlet"
		meat_type = original_atom.name

/obj/item/food/meat/rawcutlet/plain
	foodtypes = MEAT

/obj/item/food/meat/rawcutlet/plain

/obj/item/food/meat/rawcutlet/plain/human
	tastes = list("tender meat" = 1)
	foodtypes = MEAT | RAW | GROSS

/obj/item/food/meat/rawcutlet/plain/human/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/plain/human, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/plain/human/OnCreatedFromProcessing(mob/living/user, obj/item/I, list/chosen_option, atom/original_atom)
	. = ..()
	if(istype(original_atom, /obj/item/food/meat))
		var/obj/item/food/meat/origin_meat = original_atom
		subjectname = origin_meat.subjectname
		subjectjob = origin_meat.subjectjob
		if(subjectname)
			name = "raw [origin_meat.subjectname] cutlet"
		else if(subjectjob)
			name = "raw [origin_meat.subjectjob] cutlet"

/obj/item/food/meat/rawcutlet/killertomato
	name = "raw killer tomato cutlet"
	tastes = list("tomato" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/rawcutlet/killertomato/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/killertomato, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/bear
	name = "raw bear cutlet"
	tastes = list("meat" = 1, "salmon" = 1)

/obj/item/food/meat/rawcutlet/bear/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_BEAR, CELL_VIRUS_TABLE_GENERIC_MOB)

/obj/item/food/meat/rawcutlet/bear/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/bear, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)
/obj/item/food/meat/rawcutlet/xeno
	name = "raw xeno cutlet"
	tastes = list("meat" = 1, "acid" = 1)

/obj/item/food/meat/rawcutlet/xeno/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/xeno, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/spider
	name = "raw spider cutlet"
	tastes = list("cobwebs" = 1)

/obj/item/food/meat/rawcutlet/spider/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/spider, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)
/obj/item/food/meat/rawcutlet/gondola
	name = "raw gondola cutlet"
	tastes = list("meat" = 1, "tranquility" = 1)

/obj/item/food/meat/rawcutlet/gondola/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/gondola, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)
/obj/item/food/meat/rawcutlet/penguin
	name = "raw penguin cutlet"
	tastes = list("beef" = 1, "cod fish" = 1)

/obj/item/food/meat/rawcutlet/penguin/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/penguin, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken
	name = "raw chicken cutlet"
	tastes = list("chicken" = 1)

/obj/item/food/meat/rawcutlet/chicken/MakeGrillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/cutlet/chicken, rand(35 SECONDS, 50 SECONDS), TRUE, TRUE)

/obj/item/food/meat/rawcutlet/chicken/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CHICKEN, CELL_VIRUS_TABLE_GENERIC_MOB)

//Cooked cutlets

/obj/item/food/meat/cutlet
	name = "cutlet"
	desc = "A cooked meat cutlet."
	icon_state = "cutlet"
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2)
	tastes = list("meat" = 1)
	foodtypes = MEAT
	burns_on_grill = TRUE

/obj/item/food/meat/cutlet/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MICROWAVE_COOKED, PROC_REF(OnMicrowaveCooked))

///This proc handles setting up the correct meat name for the cutlet, this should definitely be changed with the food rework.
/obj/item/food/meat/cutlet/proc/OnMicrowaveCooked(datum/source, atom/source_item, cooking_efficiency)
	SIGNAL_HANDLER
	if(istype(source_item, /obj/item/food/meat/rawcutlet))
		var/obj/item/food/meat/rawcutlet/original_cutlet = source_item
		name = "[original_cutlet.meat_type] cutlet"

/obj/item/food/meat/cutlet/plain

/obj/item/food/meat/cutlet/plain/human
	tastes = list("tender meat" = 1)
	foodtypes = MEAT | GROSS

/obj/item/food/meat/cutlet/plain/human/OnMicrowaveCooked(datum/source, atom/source_item, cooking_efficiency)
	. = ..()
	if(istype(source_item, /obj/item/food/meat))
		var/obj/item/food/meat/origin_meat = source_item
		if(subjectname)
			name = "[origin_meat.subjectname] [initial(name)]"
		else if(subjectjob)
			name = "[origin_meat.subjectjob] [initial(name)]"

/obj/item/food/meat/cutlet/killertomato
	name = "killer tomato cutlet"
	tastes = list("tomato" = 1)
	foodtypes = FRUIT

/obj/item/food/meat/cutlet/bear
	name = "bear cutlet"
	tastes = list("meat" = 1, "salmon" = 1)

/obj/item/food/meat/cutlet/xeno
	name = "xeno cutlet"
	tastes = list("meat" = 1, "acid" = 1)

/obj/item/food/meat/cutlet/spider
	name = "spider cutlet"
	tastes = list("cobwebs" = 1)

/obj/item/food/meat/cutlet/gondola
	name = "gondola cutlet"
	tastes = list("meat" = 1, "tranquility" = 1)

/obj/item/food/meat/cutlet/penguin
	name = "penguin cutlet"
	tastes = list("beef" = 1, "cod fish" = 1)

/obj/item/food/meat/cutlet/chicken
	name = "chicken cutlet"
	tastes = list("chicken" = 1)

/obj/item/food/fried_chicken
	name = "fried chicken"
	desc = "A juicy hunk of chicken meat, fried to perfection."
	icon_state = "fried_chicken1"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("chicken" = 3, "fried batter" = 1)
	foodtypes = MEAT | FRIED
	junkiness = 25
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fried_chicken/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "fried_chicken2"

/obj/item/food/forsaken_burrito
	name = "Forsaken Burrito"
	desc = "It appears to be just a regular burrito with half the wrapper still on."
	icon_state = "forsaken_burrito"
	bite_consumption = 4
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/capsaicin = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("soybeans" = 2, "meat" = 1, "tortilla" = 2)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
