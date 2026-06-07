extends BasePlayerState
class_name DeathPlayerState

##Runs when state is entered
func enter(player: Character) -> void:
	player.anim_player.play("combat/death")

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
	
	await player.anim_player.animation_finished
	closest_character.enable_control(true)
	player.enable_control(false)

##Runs during a state
func update(player: Character, delta: float) -> void:
	pass

##Runs when state is exited
func exit(player: Character) -> void:
	pass
