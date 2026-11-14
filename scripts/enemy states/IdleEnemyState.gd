extends BaseEnemyState
class_name IdleEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	enemy.anim_player.play("idle")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	if enemy.arena_manager.characters != []:
		enemy.change_state_to(States.enemy_states["hunt"])
##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	pass

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
