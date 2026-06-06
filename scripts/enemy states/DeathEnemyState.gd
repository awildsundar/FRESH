extends BaseEnemyState
class_name DeathEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	enemy.anim_player.play("death")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	pass

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	pass

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
