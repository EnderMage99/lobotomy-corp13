/mob/living/simple_animal/hostile/humanoid/fixer
	name = "fixer"
	desc = "One of the many inhabitants of the backstreets, extremely weak and skittish."
	icon_state = "flame_fixer"
	icon_living = "flame_fixer"
	icon_dead = "flame_fixer"
	move_resist = MOVE_FORCE_STRONG
	maxHealth = 1500
	health = 1500
	move_to_delay = 4
	melee_damage_lower = 11
	melee_damage_upper = 16
	rapid_melee = 2
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	del_on_death = TRUE
	var/can_act = TRUE


/mob/living/simple_animal/hostile/humanoid/fixer/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/humanoid/fixer/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = ..()
