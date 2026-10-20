extends BasePlayerState
class_name DeathPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.anim_player.play("combat/death")
	player.arena_manager.battle_lost()

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	pass

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	pass
