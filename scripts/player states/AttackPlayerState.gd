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
	
	var enemy: Enemy = player.find_nearest_candidate(0, player.character.attack_distance)
	var to_enemy: Vector3 = (player.global_position - enemy.global_position).normalized()
	var forward: Vector3 = -player.global_transform.basis.z.normalized()
	var dot_product: float = forward.dot(to_enemy)
	
	if dot_product > player.snap_angle:
		var direction_to_enemy: Vector3 = (player.global_position - enemy.global_position).normalized()
		var closest_point: Vector3 = enemy.global_position + (direction_to_enemy * enemy.hurtbox.shape.radius * 2)
	
		player.global_position = closest_point
		player.look_at(enemy.global_position, Vector3.UP, true)

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if player.animation_cancel_timer.time_left > 0.0:
		if Input.is_action_just_pressed("block") or Input.is_action_just_pressed("dodge"):
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
					body.previous_attacker = player
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
	consume_timer = 0.0
	buffer_timer = 0.0
	player.is_attacking = false
	player.buffer_input = true
	player.atk_buffer = []
