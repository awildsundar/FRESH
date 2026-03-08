class_name BaseCharacterState

##Runs when state is entered
func enter(character: Character) -> void:
	pass

##Runs a frame before update is called, allows for transitions
func transition(character: Character) -> void:
	pass

##Runs during a state
func update(character: Character, delta: float) -> void:
	pass

##Runs when state is exited
func exit(character: Character) -> void:
	pass
