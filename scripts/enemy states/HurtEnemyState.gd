extends BaseEnemyState
class_name HurtEnemyState

var desired_velocity: Vector3

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	desired_velocity = enemy.knockback_dir * enemy.enemy.knockback_strength
	print(desired_velocity)
	enemy.anim_player.play("hurt")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	if enemy.hp <= 0.0:
		enemy.change_state_to(States.enemy_states["death"])

	await enemy.anim_player.animation_finished
	enemy.change_state_to(States.enemy_states["idle"])

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	desired_velocity = desired_velocity.lerp(Vector3.ZERO, 8.0 * delta)
	
	enemy.velocity = desired_velocity
	
	enemy.move_and_slide()
##Runs when state is exited
func exit(enemy: Enemy) -> void:
	enemy.current_attacker = null
