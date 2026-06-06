extends BasePlayerState
class_name MovePlayerState

##Runs when state is entered
func enter(player: Character) -> void:
	player.anim_player.play("combat/run")

##Runs a frame before update is called, allows for transitions
func transition(player: Character) -> void:
	if player.move_dir == Vector3.ZERO:
		player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: Character, delta: float) -> void:
	player.velocity.x = player.move_dir.x * player.speed
	player.velocity.z = player.move_dir.z * player.speed

	player.move_and_slide()
	player.turn_to(player.move_dir)

##Runs when state is exited
func exit(player: Character) -> void:
	pass
