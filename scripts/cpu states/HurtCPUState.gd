extends BaseCPUState
class_name HurtCPUState

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	cpu.anim_player.play("combat/hurt")

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	if cpu.arena_manager.player_hp <= 0.0:
		cpu.change_state_to(States.player_states["death"])
	await cpu.anim_player.animation_finished
	cpu.change_state_to(States.cpu_states["idle"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
