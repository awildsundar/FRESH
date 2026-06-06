extends BasePlayerState
class_name SwitchPlayerState

##Runs when state is entered
func enter(player: Character) -> void:
	Engine.time_scale = 0.25

##Runs a frame before update is called, allows for transitions
func transition(player: Character) -> void:
	var closest_character: Character = null
	var closest_dist: float = INF
	var screen_center: Vector2 = player.get_viewport().get_visible_rect().size
	var characters: Array = player.get_tree().get_nodes_in_group("Character")
	characters.erase(player)
	
	for ch in characters:
		var ch_screen_pos: Vector2 = player.camera.unproject_position(ch.global_position)
		var dist: float = ch_screen_pos.distance_squared_to(screen_center)
		if dist < closest_dist:
			closest_dist = dist
			closest_character = ch
	
	if Input.is_action_just_released("switch_control"):
		if closest_character != null:
			player.enable_control(false)
			closest_character.enable_control(true)
	
	await player.get_tree().create_timer(0.5).timeout
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: Character, delta: float) -> void:
	player.velocity.x = player.move_dir.x * player.speed
	player.velocity.z = player.move_dir.z * player.speed

	player.move_and_slide()
	player.turn_to(player.move_dir)

##Runs when state is exited
func exit(player: Character) -> void:
	Engine.time_scale = 1.0
