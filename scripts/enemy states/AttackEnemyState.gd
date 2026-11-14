extends BaseEnemyState
class_name AttackEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	var current_target: ArenaCharacter = enemy.find_nearest_candidate()
	enemy.look_at(current_target.global_position, Vector3.UP, true)
	enemy.anim_player.play("kick1")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	await enemy.anim_player.animation_finished
	
	if enemy.combo >= enemy.enemy.max_combo:
		enemy.combo = 0
		enemy.change_state_to(States.enemy_states["back_away"])
		
	if enemy.state != States.enemy_states["back_away"]:
		enemy.change_state_to(States.enemy_states["hunt"])

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	if enemy.hitbox.enabled:
		if enemy.hitbox.is_colliding():
			var body: Object = enemy.hitbox.get_collider(0)
			if body is ArenaCharacter:
				body.hurt(enemy.atk)
				if enemy.combo >= enemy.enemy.max_combo - 1:
					enemy.enemy.status_effect.inflict_status_effect(body)
				enemy.hitbox.enabled = false

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	enemy.combo += 1
