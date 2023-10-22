/mob/living/simple_animal/hostile/abnormality/shock_centipede
	name = "Shock Centipede"
	desc = "A enormous blue Centipede with electricity sparking around it."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "helper"
	icon_living = "helper"
	maxHealth = 1700
	health = 1700
	rapid_melee = 3
	ranged = TRUE
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/helper/attack.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 25
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	speak_emote = list("screechs")
	vision_range = 14
	melee_reach = 2
	aggro_vision_range = 20
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 65,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = 10,
						ABNORMALITY_WORK_REPRESSION = list(75, 75, 95, 95, 95)
						)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/grinder,
		/datum/ego_datum/armor/grinder
		)
	gift_type =  /datum/ego_gifts/grinder
	gift_message = "Electricity crackles around you as you feel charged with power."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/* Work effects */

/* Attempt Work */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/AttemptWork(mob/living/carbon/human/user, work_type)
	//Temp too high, random damage type time.
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) <= 60)
		work_damage_amount = 14
	if(datum_reference?.qliphoth_meter == 1 && work_type == ABNORMALITY_WORK_REPRESSION)
		work_damage_type = BLACK

/* Post Work Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	work_damage_amount = 6
	work_damage_type = RED
	if(datum_reference?.qliphoth_meter == 3 && work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	if(datum_reference?.qliphoth_meter == 1 && work_type != ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)


/* Success Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference?.qliphoth_meter == 2)
		datum_reference.qliphoth_change(1)
	if(datum_reference?.qliphoth_meter == 1 && work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(2)

/* Neutral Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference?.qliphoth_meter == 2)
		if(prob(50))
			datum_reference.qliphoth_change(-1)
		else
			datum_reference.qliphoth_change(1)
	else
		if(datum_reference?.qliphoth_meter == 1 && work_type == ABNORMALITY_WORK_REPRESSION)
			datum_reference.qliphoth_change(1)

/* Failure Effect */
/mob/living/simple_animal/hostile/abnormality/shock_centipede/FailureEffect(mob/living/carbon/human/user, work_type, pe)
		datum_reference.qliphoth_change(-1)
	return

