extends BasePlayerState
class_name CounterPlayerState

var timer: SceneTreeTimer
var enemy: Enemy

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	Engine.time_scale = 0.1
	player.in_counter = true
	enemy = player.find_nearest_candidate(0, player.attack_distance)
	enemy.change_state_to(States.enemy_states["countered"])
	timer = player.get_tree().create_timer(player.counter_time)

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	if Input.is_action_just_pressed("basic_attack"):
		player.turn_to(enemy.global_position)
		player.change_state_to(States.player_states["counter_attack"])
	
	await timer.timeout
	player.in_counter = false
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	pass

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	Engine.time_scale = 1.0
