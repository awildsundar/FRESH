extends BasePlayerState
class_name SynergyAttackPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.anim_player.play(player.arena_manager.synergy_attack.animation_name)
	player.arena_manager.synergy_attack.execute_attack()
	player.arena_manager.score_manager.statuses_inflicted += 1
	player.arena_manager.score_manager.synergy_activations += 1
	
##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	await player.anim_player.animation_finished
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	pass
