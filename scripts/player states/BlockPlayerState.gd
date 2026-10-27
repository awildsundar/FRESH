extends BasePlayerState
class_name BlockPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.is_blocking = true

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if Input.is_action_just_released("block"):
		player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	print(player.is_blocking)

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	player.is_blocking = false
