// Initialize abnormality job positions based on landmark count
/proc/initialize_abnormality_job_positions()
	// This should be called after landmarks are initialized
	for(var/datum/job/rcorp_abnormality/J in SSjob.occupations)
		if(!J.landmark_type)
			continue
		var/list/landmarks = GLOB["landmark_positions_[J.landmark_type]"]
		if(landmarks)
			J.total_positions = length(landmarks)
			J.spawn_positions = length(landmarks)


// Base abnormality job class
/datum/job/rcorp_abnormality
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "your instincts"
	selection_color = "#FF6666"
	exp_requirements = 180
	maptype = "rcorp"
	departments = DEPARTMENT_R_CORP
	
	// Abnormalities don't need access or equipment
	access = list()
	minimal_access = list()
	outfit = null
	
	// Base attributes - will be overridden by the abnormality itself
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 0,
		PRUDENCE_ATTRIBUTE = 0,
		TEMPERANCE_ATTRIBUTE = 0,
		JUSTICE_ATTRIBUTE = 0
	)
	
	// Don't apply normal job stuff to abnormalities
	var/landmark_type = null
	var/abno_list = null
	var/team_assignment = null

/datum/job/rcorp_abnormality/New()
	. = ..()
	// Update positions based on landmark count when job is created
	if(landmark_type)
		var/list/landmarks = GLOB["landmark_positions_[landmark_type]"]
		if(landmarks)
			total_positions = length(landmarks)
			spawn_positions = length(landmarks)

/datum/job/rcorp_abnormality/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	// Don't call parent - we're replacing the human entirely
	if(!landmark_type || !abno_list)
		to_chat(M, "<span class='userdanger'>Error: No landmark type or abnormality list defined!</span>")
		return
		
	var/list/available_landmarks = GLOB["landmark_positions_[landmark_type]"]
	if(!length(available_landmarks))
		to_chat(M, "<span class='userdanger'>Error: No available spawn positions!</span>")
		return
		
	// Get spawn location and remove it from available list
	var/turf/spawn_loc = pick_n_take(available_landmarks)
	
	// Pick abnormality type
	var/list/abno_pool = GLOB[abno_list]
	if(!length(abno_pool))
		to_chat(M, "<span class='userdanger'>Error: No available abnormalities in pool!</span>")
		return
		
	var/abno_type = pick_n_take(abno_pool)
	
	// Spawn the abnormality
	var/mob/living/simple_animal/hostile/abnormality/A = new abno_type(spawn_loc)
	
	// Set team if applicable
	if(team_assignment)
		A.rcorp_team = team_assignment
	
	// Transfer mind to abnormality
	if(H.mind)
		H.mind.transfer_to(A)
	
	// Notify the player
	to_chat(A, "<span class='notice'>You have become [A.name]!</span>")
	to_chat(A, "<span class='notice'>[job_notice]</span>")
	
	// Delete the human body
	qdel(H)

// Easy Combat Abnormality
/datum/job/rcorp_abnormality/easy_combat
	title = "Easy Combat Abno"
	landmark_type = "easycombat"
	abno_list = "easycombat"
	team_assignment = "easy"
	job_notice = "You are a combat-focused abnormality. Work with your team to defeat the enemy."
	selection_color = "#FFB366"
	display_order = 20

// Easy Support Abnormality
/datum/job/rcorp_abnormality/easy_support
	title = "Easy Support Abno"
	landmark_type = "easysupport"
	abno_list = "easysupport"
	team_assignment = "easy"
	job_notice = "You are a support abnormality. Aid your allies and disrupt enemies."
	selection_color = "#66FFB3"
	display_order = 21

// Easy Tank Abnormality
/datum/job/rcorp_abnormality/easy_tank
	title = "Easy Tank Abno"
	landmark_type = "easytank"
	abno_list = "easytank"
	team_assignment = "easy"
	job_notice = "You are a tank abnormality. Protect your allies and absorb damage."
	selection_color = "#66B3FF"
	display_order = 22

// Hard Combat Abnormality
/datum/job/rcorp_abnormality/hard_combat
	title = "Hard Combat Abno"
	landmark_type = "hardcombat"
	abno_list = "hardcombat"
	team_assignment = null
	job_notice = "You are a powerful combat abnormality. Destroy all who oppose you."
	selection_color = "#FF3333"
	exp_requirements = 360
	display_order = 23

// Hard Support Abnormality
/datum/job/rcorp_abnormality/hard_support
	title = "Hard Support Abno"
	landmark_type = "hardsupport"
	abno_list = "hardsupport"
	team_assignment = null
	job_notice = "You are a powerful support abnormality. Control the battlefield."
	selection_color = "#33FF66"
	exp_requirements = 360
	display_order = 24

// Hard Tank Abnormality
/datum/job/rcorp_abnormality/hard_tank
	title = "Hard Tank Abno"
	landmark_type = "hardtank"
	abno_list = "hardtank"
	team_assignment = null
	job_notice = "You are a powerful tank abnormality. You are nearly unstoppable."
	selection_color = "#3366FF"
	exp_requirements = 360
	display_order = 25

// Rhinobuster Abnormality
/datum/job/rcorp_abnormality/rhinobuster
	title = "Rhinobuster Abno"
	landmark_type = "rhinobuster"
	abno_list = "rhinobuster"
	team_assignment = null
	job_notice = "You are an extremely powerful abnormality. Show no mercy."
	selection_color = "#CC00CC"
	exp_requirements = 480
	display_order = 26

// Raidboss Abnormality
/datum/job/rcorp_abnormality/raidboss
	title = "Raidboss"
	landmark_type = "raidboss"
	abno_list = "raidboss"
	team_assignment = null
	job_notice = "You are the ultimate threat. All shall fear your power."
	selection_color = "#990000"
	exp_requirements = 600
	total_positions = 1
	spawn_positions = 1
	display_order = 27