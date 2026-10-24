extends BaseEnemyState
class_name DeathEnemyState

##Runs when state is entered
func enter(enemy: Enemy) -> void:
	enemy.limit_area.monitoring = false
	
	
	enemy.anim_player.play("death")
	enemy.arena_manager.enemies.erase(enemy)
	if enemy.arena_manager.enemies.is_empty():
		enemy.arena_manager.battle_won()

##Runs a frame before update is called, allows for transitions
func transition(enemy: Enemy) -> void:
	await enemy.anim_player.animation_finished
	exit(enemy)

##Runs during a state
func update(enemy: Enemy, delta: float) -> void:
	pass

##Runs when state is exited
func exit(enemy: Enemy) -> void:
	enemy.queue_free()
