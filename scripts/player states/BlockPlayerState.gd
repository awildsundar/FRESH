extends BasePlayerState
class_name BlockPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.animation_cancel_timer.start(player.animation_cancel_time)
	player.anim_player.play("block")
##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if player.animation_cancel_timer.time_left > 0.0:
		if Input.is_anything_pressed():
			if Input.is_action_pressed("block") == false:
				player.change_state_to(States.player_states["idle"])
	
	await player.anim_player.animation_finished
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	pass
