extends BasePlayerState
class_name BlockPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.anim_player.play("block")
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
