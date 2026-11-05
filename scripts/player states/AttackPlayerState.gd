extends BasePlayerState
class_name AttackPlayerState

var consume_timer := 0.0
var buffer_timer := 0.0
var atk_count: int = 0
var basic_atk_count: int = 0

var rest_timer: SceneTreeTimer

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.is_attacking = true
	player.animation_cancel_timer.start(player.animation_cancel_time)
	atk_count += 1
	
	if player.atk_buffer != []:
		play_attack_animation(player)

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if player.animation_cancel_timer.time_left > 0.0:
		if Input.is_anything_pressed():
			if Input.is_action_pressed("basic_attack") == false:
				player.atk_buffer = []
				player.change_state_to(States.player_states["idle"])
	
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
				body.hurt(player, player.atk * player.arena_manager.synergy_combo_mult)
				if atk_count >= player.max_buffer_size:
					body.start_synergy_combo()
					atk_count = 0
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
		basic_atk_count += 1
		if basic_atk_count >= 2:
			player.anim_player.play("punch2")
			basic_atk_count = 0
		else:
			player.anim_player.play("punch1")

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	buffer_timer = 0.0
	player.is_attacking = false
	player.buffer_input = true
	player.atk_buffer = []
