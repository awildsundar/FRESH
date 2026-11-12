extends BaseCPUState
class_name SynergyAttackCPUState

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	cpu.anim_player.play(cpu.arena_manager.synergy_attack.animation_name)

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	await cpu.anim_player.animation_finished
	cpu.change_state_to(States.cpu_states["idle"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
