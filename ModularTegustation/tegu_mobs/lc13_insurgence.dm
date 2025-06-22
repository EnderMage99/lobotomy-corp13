// Fluff structures for LC13

/obj/structure/fluff/street_light
	name = "stoplight"
	desc = "A traffic control device. This one seems to be stuck on red."
	icon = 'icons/obj/fluff_64x64.dmi'
	icon_state = "street_light"
	pixel_x = -16
	density = TRUE
	anchored = TRUE
	light_range = 6
	light_power = 4

/obj/structure/fluff/parking_sign
	name = "parking sign"
	desc = "A sign indicating a parking area. The paint is slightly faded."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "parking_sign"
	density = FALSE
	anchored = TRUE

/obj/item/quest_ticket/insurgence_1
	name = "'U-Corp Alleyway' ticket"
	desc = "A small sheet of paper with a barcode. Could be given to a ticket reader to access to a new area."
	map = "_maps/Quests/insurgence_1.dmm"
	map_name = "insurgence_1"
	ticket_name = "U-Corp Alleyway"

// Insurgence Agent NPC
/mob/living/simple_animal/hostile/ui_npc/insurgence_agent
	name = "insurgence agent"
	desc = "A suspicious individual in dark clothing. They seem to be watching their surroundings carefully."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "syndicate"
	maxHealth = 100
	health = 100
	speed = 1
	faction = list("neutral")
	portrait = "insurgence-agent.PNG"
	start_scene_id = "intro"
	random_emotes = "adjusts their collar;looks around suspiciously;checks their watch"
	bubble = "default2"

/mob/living/simple_animal/hostile/ui_npc/insurgence_agent/Initialize()
	. = ..()

	// Load dialogue scenes
	scene_manager.load_scenes(list(
		"intro" = list(
			"text" = "You shouldn't be here, citizen. Move along before there's trouble.",
			"actions" = list(
				"ask_about_area" = list(
					"text" = "What is this place?",
					"default_scene" = "explain_area"
				),
				"threaten" = list(
					"text" = "Are you threatening me?",
					"default_scene" = "warning"
				),
				"leave" = list(
					"text" = "I'll be on my way.",
					"default_scene" = "goodbye"
				)
			)
		),
		"explain_area" = list(
			"text" = "This is a restricted zone. U-Corp operations. You don't have clearance to be here.",
			"actions" = list(
				"back" = list(
					"text" = "I see...",
					"default_scene" = "intro"
				),
				"insist" = list(
					"text" = "I have business here.",
					"default_scene" = "warning"
				)
			)
		),
		"warning" = list(
			"text" = "Listen carefully - turn around and walk away. This is your only warning.",
			"actions" = list(
				"comply" = list(
					"text" = "Fine, I'm leaving.",
					"default_scene" = "goodbye"
				),
				"refuse" = list(
					"text" = "I'm not going anywhere.",
					"default_scene" = "hostile"
				)
			)
		),
		"goodbye" = list(
			"text" = "Smart choice. Don't come back.",
			"actions" = list()
		),
		"hostile" = list(
			"text" = "You've made a mistake. We tried to warn you!",
			"actions" = list()
		),
		"already_hostile" = list(
			"text" = "You shouldn't have come here! Now you'll pay the price!",
			"actions" = list()
		)
	))

/mob/living/simple_animal/hostile/ui_npc/insurgence_agent/proc/become_hostile()
	if("hostile" in faction)
		return
	faction = list("hostile")
	start_scene_id = "already_hostile"
	visible_message(span_warning("[src] draws a weapon and takes a hostile stance!"))

// Insurgence Truck Area
/area/insurgence_truck
	name = "insurgence truck"
	desc = "The interior of a suspicious-looking truck. Various equipment and supplies are scattered about."
	icon_state = "away"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NO_ALERTS
	var/last_alarm_time = 0
	var/alarm_cooldown = 300 // 30 seconds in deciseconds

/area/insurgence_truck/Entered(atom/movable/M)
	. = ..()
	if(!isliving(M))
		return

	var/mob/living/entrant = M
	if(!entrant.client) // Only trigger for player-controlled mobs
		return

	// Find all insurgence agents in view and make them hostile
	var/agents_triggered = FALSE
	for(var/mob/living/simple_animal/hostile/ui_npc/insurgence_agent/agent in livinginrange(7, M))
		if(!("hostile" in agent.faction))
			agent.become_hostile()
			agent.target = entrant
			agents_triggered = TRUE

	// Only play alarm if agents were triggered and cooldown has passed
	if(agents_triggered && (world.time >= last_alarm_time + alarm_cooldown))
		visible_message(span_danger("An alarm starts blaring from somewhere in the truck!"))
		playsound(src, 'sound/weapons/ego/devyat_alarm.ogg', 50, TRUE)
		last_alarm_time = world.time
