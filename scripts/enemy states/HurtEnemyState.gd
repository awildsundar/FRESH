extends BaseEnemyState
class_name HurtEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	enemy.anim_player.play("hurt")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	if enemy.hp <= 0.0:
		enemy.change_state_to(States.enemy_states["death"])

	await enemy.anim_player.animation_finished
	enemy.change_state_to(States.enemy_states["idle"])

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	pass

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
