extends BaseCPUState
class_name IdleCPUState

##Runs when state is entered
func enter(cpu: Character) -> void:
	cpu.anim_player.play("combat/idle")

##Runs a frame before update is called, allows for transitions
func transition(cpu: Character) -> void:
	pass

##Runs during a state
func update(cpu: Character, delta: float) -> void:
	pass

##Runs when state is exited
func exit(cpu: Character) -> void:
	pass
