extends BaseEnemyState
class_name CircleEnemyState

# 1 = left, -1 = right
var circle_direction: int = 1 
var circle_timer: float = 0.0
var target_circle_time: float = 0.0

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	circle_direction = 1 if randf() > 0.5 else -1
	target_circle_time = randf_range(enemy.min_circle_time, enemy.max_circle_time)
	circle_timer = 0.0
	enemy.anim_player.play("run")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	if enemy.target != null:
		var to_player: Vector3 = (enemy.target.global_position - enemy.global_position)
		var distance: float = to_player.length()
		
		
		if circle_timer >= target_circle_time:
			if randf() < enemy.attack_chance:
				enemy.change_state_to(States.enemy_states["hunt"])
			else:
				circle_timer = 0.0
				target_circle_time = randf_range(enemy.min_circle_time, enemy.max_circle_time)
				if randf() > 0.7:
					circle_direction *= -1
		
		if distance > enemy.circle_distance * 2.0:
			enemy.change_state_to(States.enemy_states["idle"])
	else:
		enemy.change_state_to(States.enemy_states["idle"])
	
##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	circle_timer += delta
	
	var to_player: Vector3 = (enemy.target.global_position - enemy.global_position)
	var distance: float = to_player.length()
	to_player = to_player.normalized()
	
	var strafe_dir: Vector3 = to_player.cross(Vector3.UP).normalized()
	strafe_dir *= circle_direction
	
	var distance_diff: float = distance - enemy.circle_distance
	var approach_dir: Vector3 = to_player * sign(distance_diff) * 0.3
	
	var move_dir: Vector3 = (strafe_dir + approach_dir).normalized()
	move_dir.y = 0
	
	enemy.velocity.x = move_dir.x * enemy.speed * enemy.back_away_speed_mult
	enemy.velocity.z = move_dir.z * enemy.speed * enemy.back_away_speed_mult
	enemy.velocity.y = 0.0
	
	var look_target: Vector2 = Vector2(enemy.target.global_position.x, enemy.target.global_position.z)
	var enemy_rot: Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
	var dir: Vector2 = (look_target - enemy_rot)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(dir.x, dir.y), 0.5)
	
	enemy.move_and_slide()

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
