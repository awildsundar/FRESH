extends BasePlayerState
class_name IdlePlayerState

##Runs when state is entered
func enter(player: Character) -> void:
	player.anim_player.play("combat/idle")

##Runs a frame before update is called, allows for transitions
func transition(player: Character) -> void:
	if player.move_dir != Vector3.ZERO && player.can_move == true && player.in_control:
		player.change_state_to(States.player_states["move"])

##Runs during a state
func update(player: Character, delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	
	player.move_and_slide()
##Runs when state is exited
func exit(player: Character) -> void:
	pass
