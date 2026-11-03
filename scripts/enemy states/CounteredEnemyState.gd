extends BaseEnemyState
class_name CounteredEnemyState

var timer: SceneTreeTimer

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	timer = enemy.get_tree().create_timer(enemy.target.counter_time)

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	await timer.timeout
	enemy.change_state_to(States.enemy_states["idle"])

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	pass

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
