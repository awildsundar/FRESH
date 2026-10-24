extends BasePlayerState
class_name SwitchPlayerState

var closest_character: ArenaCharacter = null


##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	Engine.time_scale = 0.25

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if Input.is_action_just_released("switch_control"):
		if closest_character != null:
			player.enable_control(false)
			closest_character.enable_control(true)
		else:
			player.change_state_to(States.player_states["idle"])
	
	await player.get_tree().create_timer(0.5).timeout
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	var closest_dist: float = INF
	var screen_center: Vector2 = player.get_viewport().get_visible_rect().size
	var characters: Array = player.arena_manager.characters
	var filtered_characters: Array = characters.filter(func(ch): return not ch.in_control == true)
	
	for ch: ArenaCharacter in filtered_characters:
		var ch_screen_pos: Vector2 = player.camera.unproject_position(ch.global_position)
		var dist: float = ch_screen_pos.distance_squared_to(screen_center)
		if dist < closest_dist and player.camera.is_position_in_frustum(ch.global_position):
			closest_dist = dist
			closest_character = ch
	
	player.velocity.x = player.move_dir.x * player.speed
	player.velocity.z = player.move_dir.z * player.speed

	player.move_and_slide()
	player.turn_to(player.move_dir)

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	Engine.time_scale = 1.0
