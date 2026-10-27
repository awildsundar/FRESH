extends BaseState
class_name BaseCPUState

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	pass

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	pass

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
