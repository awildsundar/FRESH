extends BaseEnemyState
class_name BackAwayEnemyState

var back_away_timer: float = 0.0

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	back_away_timer = 0.0
	enemy.limit_area.monitoring = false
	enemy.anim_player.play("run")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	var distance: float = enemy.global_position.distance_to(enemy.target.global_position)
	
	if distance >= enemy.back_away_distance:
		enemy.change_state_to(States.enemy_states["circle"])

	if back_away_timer >= enemy.back_away_timer:
		enemy.change_state_to(States.enemy_states["circle"])
	

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	back_away_timer += delta
	
	var to_player: Vector3 = (enemy.target.global_position - enemy.global_position).normalized()
	var retreat_dir: Vector3 = -to_player
	retreat_dir.y = 0
	
	enemy.velocity.x = retreat_dir.x * (enemy.speed * enemy.back_away_speed_mult)
	enemy.velocity.z = retreat_dir.z * (enemy.speed * enemy.back_away_speed_mult)

	
	var look_target: Vector2 = Vector2(enemy.target.global_position.x, enemy.target.global_position.z)
	var enemy_rot: Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
	var dir: Vector2 = (look_target - enemy_rot)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(dir.x, dir.y), 0.5)
	
	enemy.move_and_slide()
	
##Runs when state is exited
func exit(enemy: Enemy) -> void:
	enemy.limit_area.monitoring = true
