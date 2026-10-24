extends BaseEnemyState
class_name AttackEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	var current_target: Node3D = enemy.find_nearest_candidate()
	var look_target: Vector2 = Vector2(current_target.global_position.x, current_target.global_position.z)
	var enemy_rot: Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
	var dir: Vector2 = (look_target - enemy_rot)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(dir.x, dir.y), 0.5)
	enemy.anim_player.play("kick1")
	enemy.combo += 1

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	await enemy.anim_player.animation_finished
	
	if enemy.combo >= enemy.max_combo:
		enemy.combo = 0
		enemy.change_state_to(States.enemy_states["back_away"])

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	if enemy.hitbox.enabled:
		if enemy.hitbox.is_colliding():
			var body: Object = enemy.hitbox.get_collider(0)
			if body is ArenaCharacter:
				body.hurt(enemy.atk)
				enemy.hitbox.enabled = false

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
