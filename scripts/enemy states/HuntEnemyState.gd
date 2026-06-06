extends BaseEnemyState
class_name HuntEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	enemy.anim_player.play("run")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	var current_target: Node3D = enemy.find_nearest_candidate("Character")
	var body: Array[Node3D] = enemy.limit_area.get_overlapping_bodies()
	if current_target == null:
		enemy.change_state_to(States.enemy_states["idle"])
	for node in body:
		if node is Character:
			if node.hp > 0.0:
				enemy.change_state_to(States.enemy_states["attack"])

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	var current_target: Node3D = enemy.find_nearest_candidate("Character")
	if current_target != null && enemy.limit_area.has_overlapping_bodies() == false:
		var look_target: Vector2 = Vector2(current_target.global_position.x, current_target.global_position.z)
		var enemy_rot: Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
		var dir: Vector2 = (look_target - enemy_rot)
		enemy.mesh.rotation.y = lerp_angle(enemy.mesh.rotation.y, atan2(dir.x, dir.y), 0.5)

		enemy.velocity = Vector3.ZERO
		enemy.nav_agent.target_position = current_target.global_position
		var next_point: Vector3 = enemy.nav_agent.get_next_path_position()
		enemy.velocity = (next_point - enemy.global_position).normalized() * enemy.speed
	
	enemy.move_and_slide()

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
