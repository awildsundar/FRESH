extends BaseEnemyState
class_name IdleEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	enemy.anim_player.play("idle")

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	if enemy.detection_area.get_overlapping_bodies() && enemy.limit_area.has_overlapping_bodies() == false:
		for body in enemy.detection_area.get_overlapping_bodies():
			if body is Character:
				enemy.change_state_to(States.enemy_states["hunt"])

	#if enemy.limit_area.get_overlapping_bodies():
		#for body in enemy.limit_area.get_overlapping_bodies():
			#if body is Character && enemy.state != States.enemy_states["hurt"]:
				#enemy.change_state_to(States.enemy_states["attack"])
##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	pass

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	pass
