extends BaseCPUState
class_name CircleCPUState

# 1 = left, -1 = right
var circle_direction: int = 1 
var circle_timer: float = 0.0
var target_circle_time: float = 0.0

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	circle_direction = 1 if randf() > 0.5 else -1
	target_circle_time = randf_range(cpu.min_circle_time, cpu.max_circle_time)
	circle_timer = 0.0
	cpu.anim_player.play("combat/run")

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	var to_player: Vector3 = (cpu.target.global_position - cpu.global_position)
	var distance: float = to_player.length()
	
	
	if circle_timer >= target_circle_time:
		if randf() < cpu.attack_chance:
			cpu.change_state_to(States.cpu_states["hunt"])
		else:
			circle_timer = 0.0
			target_circle_time = randf_range(cpu.min_circle_time, cpu.max_circle_time)
			if randf() > 0.7:
				circle_direction *= -1
	
	if distance > cpu.circle_distance * 2.0:
		cpu.change_state_to(States.cpu_states["idle"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	circle_timer += delta
	
	var to_player: Vector3 = (cpu.target.global_position - cpu.global_position)
	var distance: float = to_player.length()
	to_player = to_player.normalized()
	
	var strafe_dir: Vector3 = to_player.cross(Vector3.UP).normalized()
	strafe_dir *= circle_direction
	
	var distance_diff: float = distance - cpu.circle_distance
	var approach_dir: Vector3 = to_player * sign(distance_diff) * 0.3
	
	var move_dir: Vector3 = (strafe_dir + approach_dir).normalized()
	move_dir.y = 0
	
	cpu.velocity.x = move_dir.x * cpu.speed * cpu.back_away_speed_mult
	cpu.velocity.z = move_dir.z * cpu.speed * cpu.back_away_speed_mult
	
	var look_target: Vector2 = Vector2(cpu.target.global_position.x, cpu.target.global_position.z)
	var cpu_rot: Vector2 = Vector2(cpu.global_position.x, cpu.global_position.z)
	var dir: Vector2 = (look_target - cpu_rot)
	cpu.rotation.y = lerp_angle(cpu.rotation.y, atan2(dir.x, dir.y), 0.5)
	
	cpu.global_position.y = 0
	
	cpu.move_and_slide()

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
