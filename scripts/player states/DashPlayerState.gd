extends BasePlayerState
class_name DashPlayerState

##Runs when state is entered
func enter(player: Character) -> void:
	player.anim_player.play("combat/run")
	player.anim_player.speed_scale = 2.0

##Runs a frame before update is called, allows for transitions
func transition(player: Character) -> void:
	if player.move_dir == Vector3.ZERO:
		player.anim_player.speed_scale = 1.0
		player.change_state_to(States.player_states["idle"])
	await player.get_tree().create_timer(player.dash_time).timeout
	player.anim_player.speed_scale = 1.0
	player.change_state_to(States.player_states["move"])

##Runs during a state
func update(player: Character, delta: float) -> void:
	player.velocity.x = player.move_dir.x * player.speed * 2.0
	player.velocity.z = player.move_dir.z * player.speed * 2.0

	player.move_and_slide()
	player.turn_to(player.move_dir)

##Runs when state is exited
func exit(player: Character) -> void:
	pass
