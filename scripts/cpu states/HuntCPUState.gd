extends BaseCPUState
class_name HuntCPUState

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	cpu.anim_player.play("combat/run")

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	var current_target: Node3D = cpu.find_nearest_candidate(0, cpu.control_distance)
	var body: Array[Node3D] = cpu.limit_area.get_overlapping_bodies()
	if current_target == null:
		cpu.change_state_to(States.cpu_states["idle"])
	for node in body:
		if node is Enemy:
			if node.hp > 0.0:
				cpu.change_state_to(States.cpu_states["attack"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	var current_target: Node3D = cpu.find_nearest_candidate(0, cpu.control_distance)
	if current_target != null && cpu.limit_area.has_overlapping_bodies() == false:
		var look_target: Vector2 = Vector2(current_target.global_position.x, current_target.global_position.z)
		var cpu_rot: Vector2 = Vector2(cpu.global_position.x, cpu.global_position.z)
		var dir: Vector2 = (look_target - cpu_rot)
		cpu.rotation.y = lerp_angle(cpu.rotation.y, atan2(dir.x, dir.y), 0.5)

		cpu.velocity = Vector3.ZERO
		cpu.nav_agent.target_position = current_target.global_position
		var next_point: Vector3 = cpu.nav_agent.get_next_path_position()
		cpu.velocity = (next_point - cpu.global_position).normalized() * cpu.speed
	
	cpu.move_and_slide()

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	pass
