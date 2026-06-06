extends BaseState
class_name BaseCPUState

##Runs when state is entered
func enter(cpu: Character) -> void:
	pass

##Runs a frame before update is called, allows for transitions
func transition(cpu: Character) -> void:
	pass

##Runs during a state
func update(cpu: Character, delta: float) -> void:
	pass

##Runs when state is exited
func exit(cpu: Character) -> void:
	pass
