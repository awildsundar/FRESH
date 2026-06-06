extends BasePlayerState
class_name AttackPlayerState

##Runs when state is entered
func enter(player: Character) -> void:
	player.anim_player.play("combat/punch1")

##Runs a frame before update is called, allows for transitions
func transition(player: Character) -> void:
	await player.anim_player.animation_finished
	if player.in_control:
		player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: Character, delta: float) -> void:
	if player.hitbox.enabled:
		if player.hitbox.is_colliding():
			var body: Object = player.hitbox.get_collider(0)
			if body is Enemy:
				body.hurt(player.atk)
				player.hitbox.enabled = false

##Runs when state is exited
func exit(player: Character) -> void:
	pass
