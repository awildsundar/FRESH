extends BasePlayerState
class_name IdlePlayerState

##Runs when state is entered
func enter(player) -> void:
	player.anim_player.play("idle")

##Runs a frame before update is called, allows for transitions
func transition(player) -> void:
	if player.move_dir != Vector3.ZERO && player.can_move == true:
		if player is ArenaCharacter:
			if player.in_control == false:
				return
		player.change_state_to(States.player_states["move"])

##Runs during a state
func update(player, delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	
	player.move_and_slide()
##Runs when state is exited
func exit(player) -> void:
	pass
