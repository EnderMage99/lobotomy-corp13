/client/proc/villains_join()
	set name = "Join Villains Game"
	set category = "Admin"
	set desc = "Join the Villains game lobby"
	
	if(!holder)
		return
	
	var/datum/villains_simple_controller/game = get_villains_game()
	if(!mob)
		to_chat(src, "<span class='warning'>You need a mob to join!</span>")
		return
	
	if(game.add_player(mob))
		to_chat(src, "<span class='notice'>You have joined the Villains game!</span>")

/client/proc/villains_leave()
	set name = "Leave Villains Game"
	set category = "Admin"
	set desc = "Leave the Villains game"
	
	if(!holder)
		return
	
	var/datum/villains_simple_controller/game = get_villains_game()
	if(!mob)
		return
	
	if(game.remove_player(mob))
		to_chat(src, "<span class='notice'>You have left the Villains game.</span>")

/client/proc/villains_start()
	set name = "Start Villains Game"
	set category = "Admin"
	set desc = "Start the Villains game (Admin only)"
	
	if(!holder)
		return
	
	var/datum/villains_simple_controller/game = get_villains_game()
	if(game.start_game())
		message_admins("[key_name_admin(src)] has started the Villains game.")

/client/verb/villains_eliminate()
	set name = "Eliminate Player"
	set category = "Villains"
	set desc = "Eliminate a player (Villain only)"
	
	var/datum/villains_simple_controller/game = get_villains_game()
	if(!mob || game.villain != mob)
		to_chat(src, "<span class='warning'>Only the villain can use this command!</span>")
		return
	
	var/list/targets = list()
	for(var/mob/M in game.players)
		if(M != mob && !(M in game.dead_players))
			targets += M
	
	if(!targets.len)
		to_chat(src, "<span class='warning'>No valid targets!</span>")
		return
	
	var/mob/target = input(src, "Choose a player to eliminate:", "Eliminate") as null|anything in targets
	if(!target)
		return
	
	if(game.eliminate_player(mob, target))
		to_chat(src, "<span class='danger'>You have eliminated [target.name]!</span>")

/client/proc/villains_status()
	set name = "Villains Game Status"
	set category = "Admin"
	set desc = "Check the current game status"
	
	if(!holder)
		return
	
	var/datum/villains_simple_controller/game = get_villains_game()
	
	to_chat(src, "<span class='notice'>--- Villains Game Status ---</span>")
	to_chat(src, "Game Active: [game.game_active ? "Yes" : "No"]")
	to_chat(src, "Phase: [game.phase]")
	to_chat(src, "Players: [game.players.len]")
	
	if(mob in game.players)
		to_chat(src, "You are [mob == game.villain ? "<span class='danger'>the VILLAIN</span>" : "an innocent player"]")
		
		var/alive_list = ""
		var/dead_list = ""
		for(var/mob/M in game.players)
			if(M in game.dead_players)
				dead_list += "[M.name], "
			else
				alive_list += "[M.name], "
		
		if(alive_list)
			to_chat(src, "Alive: [copytext(alive_list, 1, -2)]")
		if(dead_list)
			to_chat(src, "<span class='danger'>Dead: [copytext(dead_list, 1, -2)]</span>")

/client/proc/villains_force_end()
	set name = "Force End Villains Game"
	set category = "Admin"
	set desc = "Force end the current Villains game (Admin only)"
	
	if(!holder)
		return
	
	var/datum/villains_simple_controller/game = get_villains_game()
	game.end_game("admin_ended")
	message_admins("[key_name_admin(src)] has force ended the Villains game.")

/client/proc/villains_add_player()
	set name = "Add Player to Villains Game"
	set category = "Admin"
	set desc = "Add another player to the Villains game"
	
	if(!holder)
		return
	
	var/datum/villains_simple_controller/game = get_villains_game()
	
	var/list/available_mobs = list()
	for(var/mob/M in GLOB.player_list)
		if(M.client && !(M in game.players))
			available_mobs += M
	
	if(!available_mobs.len)
		to_chat(src, "<span class='warning'>No available players to add!</span>")
		return
	
	var/mob/target = input(src, "Choose a player to add to the Villains game:", "Add Player") as null|anything in available_mobs
	if(!target)
		return
	
	if(game.add_player(target))
		message_admins("[key_name_admin(src)] added [key_name_admin(target)] to the Villains game.")
		to_chat(target, "<span class='notice'>You have been added to the Villains game by an admin!</span>")