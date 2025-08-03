/datum/villains_simple_controller
	var/list/players = list()
	var/mob/villain
	var/game_active = FALSE
	var/phase = "lobby"
	var/minimum_players = 2 // Lowered for testing, should be 6 for real games
	var/list/dead_players = list()
	var/list/spawn_points = list()
	var/turf/lobby_spawn

/datum/villains_simple_controller/proc/add_player(mob/player)
	if(!player || !player.client)
		return FALSE
	if(game_active)
		to_chat(player, "<span class='warning'>The game is already in progress!</span>")
		return FALSE
	if(player in players)
		to_chat(player, "<span class='warning'>You are already in the game!</span>")
		return FALSE
	
	players += player
	announce_to_players("[player.name] has joined the game! ([players.len]/[minimum_players] minimum)")
	
	teleport_to_lobby(player)
	
	if(players.len >= minimum_players)
		announce_to_players("<span class='notice'>Enough players! An admin can start the game with /villains-start</span>")
	
	return TRUE

/datum/villains_simple_controller/proc/remove_player(mob/player)
	if(!(player in players))
		return FALSE
	
	players -= player
	announce_to_players("[player.name] has left the game. ([players.len] players)")
	
	if(game_active && player == villain)
		announce_to_players("<span class='warning'>The villain has left! Game ending...</span>")
		end_game("villain_left")
	
	return TRUE

/datum/villains_simple_controller/proc/start_game()
	if(game_active)
		return FALSE
	if(players.len < minimum_players)
		announce_to_players("<span class='warning'>Not enough players! Need at least [minimum_players].</span>")
		return FALSE
	
	game_active = TRUE
	phase = "playing"
	dead_players = list()
	
	announce_to_players("<span class='danger'>The game begins!</span>")
	select_villain()
	
	return TRUE

/datum/villains_simple_controller/proc/select_villain()
	if(!players.len)
		return FALSE
	
	villain = pick(players)
	to_chat(villain, "<span class='userdanger'>You are the VILLAIN! Use /villains-eliminate to eliminate a player.</span>")
	
	for(var/mob/M in players)
		if(M != villain)
			to_chat(M, "<span class='notice'>You are an innocent player. Find the villain!</span>")
	
	announce_to_players("<span class='warning'>One among you is the villain...</span>")
	return TRUE

/datum/villains_simple_controller/proc/eliminate_player(mob/killer, mob/target)
	if(!game_active)
		to_chat(killer, "<span class='warning'>The game is not active!</span>")
		return FALSE
	
	if(killer != villain)
		to_chat(killer, "<span class='warning'>Only the villain can eliminate players!</span>")
		return FALSE
	
	if(!(target in players))
		to_chat(killer, "<span class='warning'>Target is not in the game!</span>")
		return FALSE
	
	if(target in dead_players)
		to_chat(killer, "<span class='warning'>Target is already eliminated!</span>")
		return FALSE
	
	if(target == killer)
		to_chat(killer, "<span class='warning'>You cannot eliminate yourself!</span>")
		return FALSE
	
	dead_players += target
	announce_to_players("<span class='userdanger'>[target.name] has been eliminated!</span>")
	to_chat(target, "<span class='userdanger'>You have been eliminated by the villain!</span>")
	
	check_victory()
	return TRUE

/datum/villains_simple_controller/proc/check_victory()
	var/alive_count = 0
	for(var/mob/M in players)
		if(!(M in dead_players))
			alive_count++
	
	if(alive_count <= 2)
		end_game("villain_wins")
		return TRUE
	
	return FALSE

/datum/villains_simple_controller/proc/end_game(reason)
	if(!game_active)
		return
	
	game_active = FALSE
	phase = "ended"
	
	switch(reason)
		if("villain_wins")
			announce_to_players("<span class='userdanger'>THE VILLAIN WINS! It was [villain.name]!</span>")
		if("villain_caught")
			announce_to_players("<span class='greentext'>THE VILLAIN WAS CAUGHT! It was [villain.name]!</span>")
		if("villain_left")
			announce_to_players("<span class='warning'>Game ended - villain disconnected.</span>")
	
	announce_to_players("<span class='notice'>Game over! Use /villains-join to play again.</span>")
	
	players = list()
	villain = null
	dead_players = list()

/datum/villains_simple_controller/proc/announce_to_players(message)
	for(var/mob/M in players)
		to_chat(M, message)

var/global/datum/villains_simple_controller/villains_game

/proc/get_villains_game()
	if(!villains_game)
		villains_game = new /datum/villains_simple_controller()
		villains_game.initialize_spawn_points()
	return villains_game

/datum/villains_simple_controller/proc/initialize_spawn_points()
	// Find lobby spawn
	for(var/area/villains/lobby/L in world)
		lobby_spawn = locate(/turf) in L
		if(lobby_spawn)
			break
	
	// Find room spawns
	for(var/area/villains/room/R in world)
		var/turf/T = locate(/turf) in R
		if(T)
			spawn_points += T
	
	if(!lobby_spawn)
		// Fallback to any villains area
		for(var/area/villains/A in world)
			lobby_spawn = locate(/turf) in A
			if(lobby_spawn)
				break

/datum/villains_simple_controller/proc/teleport_to_lobby(mob/player)
	if(!player || !lobby_spawn)
		return FALSE
	
	player.forceMove(lobby_spawn)
	to_chat(player, "<span class='notice'>You have been teleported to the Villains game lobby!</span>")
	return TRUE

/datum/villains_simple_controller/proc/teleport_to_spawn(mob/player)
	if(!player || !spawn_points.len)
		return FALSE
	
	var/turf/spawn_point = pick(spawn_points)
	player.forceMove(spawn_point)
	return TRUE