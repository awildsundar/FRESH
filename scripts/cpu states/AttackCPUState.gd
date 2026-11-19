extends BaseCPUState
class_name AttackCPUState

var current_target: Enemy

##Runs when state is entered
func enter(cpu: ArenaCharacter) -> void:
	current_target = cpu.find_nearest_candidate(0, cpu.character.attack_distance)
	var look_target: Vector2 = Vector2(current_target.global_position.x, current_target.global_position.z)
	var cpu_rot: Vector2 = Vector2(cpu.global_position.x, cpu.global_position.z)
	var dir: Vector2 = (look_target - cpu_rot)
	cpu.rotation.y = lerp_angle(cpu.rotation.y, atan2(dir.x, dir.y), 0.5)
	cpu.anim_player.play("punch1")
	
	if cpu.character.ranged_character == true:
		var instanced_projectile: ProjectileManager = cpu.projectile.instantiate()
		instanced_projectile.attacker = cpu
		cpu.add_child(instanced_projectile)
		instanced_projectile.global_position = cpu.projectile_pos.global_position
		instanced_projectile.global_basis = cpu.projectile_pos.global_basis

##Runs a frame before update is called, allows for transitions
func transition(cpu: ArenaCharacter) -> void:
	await cpu.anim_player.animation_finished
	
	cpu.anim_player.play("idle")
	
	await cpu.get_tree().create_timer(cpu.character.rest_time).timeout
	if cpu.combo >= cpu.character.max_combo - 1:
		cpu.combo = 0
		if cpu.character.ranged_character == false:
			cpu.change_state_to(States.cpu_states["back_away"])
		else:
			if cpu.limit_area.overlaps_body(current_target):
				cpu.change_state_to(States.cpu_states["back_away"])
			else:
				cpu.change_state_to(States.cpu_states["circle"])
		
	if cpu.character.ranged_character == false:
		if cpu.state != States.cpu_states["back_away"]:
			cpu.change_state_to(States.cpu_states["hunt"])
	else:
		if cpu.limit_area.overlaps_body(current_target):
			cpu.change_state_to(States.cpu_states["back_away"])
		else:
			cpu.change_state_to(States.cpu_states["circle"])

##Runs during a state
func update(cpu: ArenaCharacter, delta: float) -> void:
	if cpu.character.ranged_character == false:
		if cpu.hitbox.enabled:
			if cpu.hitbox.is_colliding():
				var body: Object = cpu.hitbox.get_collider(0)
				if body is Enemy:
					body.hurt(cpu, cpu.atk)
					if cpu.combo >= cpu.character.max_combo - 1:
						body.start_synergy_combo()
					cpu.hitbox.enabled = false

##Runs when state is exited
func exit(cpu: ArenaCharacter) -> void:
	cpu.combo += 1
