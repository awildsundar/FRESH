extends BasePlayerState
class_name HurtPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.anim_player.play("combat/hurt")

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if player.arena_manager.player_hp <= 0.0:
		player.change_state_to(States.player_states["death"])
	await player.animation_cancelled
	if player.move_dir != Vector3.ZERO:
		player.change_state_to(States.player_states["move"])
	await player.anim_player.animation_finished
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	pass
	
	
##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	pass
