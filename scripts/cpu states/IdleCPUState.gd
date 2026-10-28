extends BaseCPUState
class_name IdleCPUState

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	cpu.anim_player.play("idle")

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	if cpu.arena_manager.enemies != []:
		cpu.change_state_to(States.cpu_states["hunt"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
