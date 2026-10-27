extends BaseState
class_name BasePlayerState

##Runs when state is entered
func enter(player) -> void:
	pass

##Runs a frame before update is called, allows for transitions
func transition(player) -> void:
	pass

##Runs during a state
func update(player, delta: float) -> void:
	pass

##Runs when state is exited
func exit(player) -> void:
	pass
