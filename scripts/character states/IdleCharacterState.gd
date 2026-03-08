extends BaseCharacterState
class_name IdleCharacterState

##Runs when state is entered
func enter(character: Character) -> void:
	character.anim_player.play("combat/idle")

##Runs a frame before update is called, allows for transitions
func transition(character: Character) -> void:
	if character.move_dir != Vector3.ZERO && character.can_move == true:
		character.change_state_to(States.character_states["move"])

##Runs during a state
func update(character: Character, delta: float) -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, character.speed)
	character.velocity.z = move_toward(character.velocity.z, 0, character.speed)
	
	character.move_and_slide()
##Runs when state is exited
func exit(character: Character) -> void:
	pass
