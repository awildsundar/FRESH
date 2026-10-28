extends BasePlayerState
class_name AttackPlayerState

var consume_timer := 0.0
var buffer_timer := 0.0

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.is_attacking = true
	
	if player.atk_buffer != []:
		play_attack_animation(player)

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if player.atk_buffer == []:
		await player.anim_player.animation_finished
		player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	consume_timer += delta
	buffer_timer += delta
	
	if player.hitbox.enabled:
		if player.hitbox.is_colliding():
			var body: Object = player.hitbox.get_collider(0)
			if body is Enemy:
				body.hurt(player.atk)
				player.hitbox.enabled = false
	
	if consume_timer > player.anim_player.current_animation_length - player.anim_duration:
		if player.atk_buffer != []:
			play_attack_animation(player)
		consume_timer = 0.0
	
	if buffer_timer > player.buffer_duration:
		player.buffer_input = false

func play_attack_animation(player: ArenaCharacter) -> void:
	var action: InputEvent = player.atk_buffer.pop_front()
	if action.is_action("basic_attack"):
		player.anim_player.play("punch1")
	elif action.is_action("heavy_attack"):
		player.anim_player.play("kick1")
	elif action.is_action("special_attack"):
		player.anim_player.play("kick2")

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	buffer_timer = 0.0
	player.is_attacking = false
	player.buffer_input = true
	player.atk_buffer = []
