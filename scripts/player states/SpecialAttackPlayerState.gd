extends BasePlayerState
class_name SpecialAttackPlayerState

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.anim_player.play(player.character.special_attack.animation_name)
	player.is_invincible = true

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	await player.anim_player.animation_finished
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	if player.hitbox.enabled == true:
		if player.hitbox.is_colliding():
			var body: Object = player.hitbox.get_collider(0)
			
			if body is ArenaCharacter:
				if player.character.special_attack.character_target == body.character.character_name:
					player.character.special_attack.character_status_effect.inflict_status_effect(body)
					player.hitbox.enabled = false
			
			match player.character.special_attack.main_target:
				SpecialAttack.MAIN_TARGET.SINGLE:
					if body is Enemy:
						body.hurt(player, player.character.special_attack.damage)
						player.character.special_attack.status_effect.inflict_status_effect(body)
						player.hitbox.enabled = false

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	player.is_invincible = false
	player.special_attack_timer.start(player.character.special_attack.cooldown)
