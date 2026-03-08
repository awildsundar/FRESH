extends BaseCharacterState
class_name DashCharacterState

##Runs when state is entered
func enter(character: Character) -> void:
	character.anim_player.play("combat/run")
	character.anim_player.speed_scale = 2.0

##Runs a frame before update is called, allows for transitions
func transition(character: Character) -> void:
	if character.move_dir == Vector3.ZERO:
		character.anim_player.speed_scale = 1.0
		character.change_state_to(States.character_states["idle"])
	await character.get_tree().create_timer(character.dash_time).timeout
	character.anim_player.speed_scale = 1.0
	character.change_state_to(States.character_states["move"])

##Runs during a state
func update(character: Character, delta: float) -> void:
	character.velocity.x = character.move_dir.x * character.speed * 2.0
	character.velocity.z = character.move_dir.z * character.speed * 2.0

	character.move_and_slide()
	character.turn_to(character.move_dir)

##Runs when state is exited
func exit(character: Character) -> void:
	pass
