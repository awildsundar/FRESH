extends BaseCPUState
class_name BackAwayCPUState

var back_away_timer: float = 0.0

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	back_away_timer = 0.0
	cpu.combo = 0
	cpu.anim_player.play_backwards("run")

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	var distance: float = cpu.global_position.distance_to(cpu.target.global_position)
	
	if distance >= cpu.back_away_distance:
		cpu.change_state_to(States.cpu_states["circle"])

	if back_away_timer >= cpu.back_away_timer:
		cpu.change_state_to(States.cpu_states["circle"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	back_away_timer += delta
	
	var to_player: Vector3 = (cpu.target.global_position - cpu.global_position).normalized()
	var retreat_dir: Vector3 = -to_player
	retreat_dir.y = 0
	
	cpu.velocity.x = retreat_dir.x * (cpu.speed * cpu.back_away_speed_mult)
	cpu.velocity.z = retreat_dir.z * (cpu.speed * cpu.back_away_speed_mult)
	cpu.velocity.y = 0.0
	
	var look_target: Vector2 = Vector2(cpu.target.global_position.x, cpu.target.global_position.z)
	var cpu_rot: Vector2 = Vector2(cpu.global_position.x, cpu.global_position.z)
	var dir: Vector2 = (look_target - cpu_rot)
	cpu.mesh_main.rotation.y = lerp_angle(cpu.rotation.y, atan2(dir.x, dir.y), 0.5)
	
	cpu.move_and_slide()

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
