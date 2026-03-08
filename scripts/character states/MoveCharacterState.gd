extends BaseCharacterState
class_name MoveCharacterState

##Runs when state is entered
func enter(character: Character) -> void:
	character.anim_player.play("combat/run")

##Runs a frame before update is called, allows for transitions
func transition(character: Character) -> void:
	if character.move_dir == Vector3.ZERO:
		character.change_state_to(States.character_states["idle"])

##Runs during a state
func update(character: Character, delta: float) -> void:
	character.velocity.x = character.move_dir.x * character.speed
	character.velocity.z = character.move_dir.z * character.speed

	character.move_and_slide()
	character.turn_to(character.move_dir)

##Runs when state is exited
func exit(character: Character) -> void:
	pass
