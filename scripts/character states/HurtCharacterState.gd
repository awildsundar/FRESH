extends BaseCharacterState
class_name HurtCharacterState

##Runs when state is entered
func enter(character: Character) -> void:
	character.anim_player.play("combat/hurt")

##Runs a frame before update is called, allows for transitions
func transition(character: Character) -> void:
	await character.animation_cancelled
	if character.move_dir != Vector3.ZERO:
		character.change_state_to(States.character_states["move"])
	await character.anim_player.animation_finished
	character.change_state_to(States.character_states["idle"])

##Runs during a state
func update(character: Character, delta: float) -> void:
	pass
	
	
##Runs when state is exited
func exit(character: Character) -> void:
	pass
