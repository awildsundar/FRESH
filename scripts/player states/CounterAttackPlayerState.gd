extends BasePlayerState
class_name CounterAttackPlayerState

var enemy: Enemy

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	enemy = player.find_nearest_candidate(0, player.attack_distance)
	player.anim_player.play_section("punch1", 0.45)
	enemy.hurt(player.atk * 2.0)

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	await player.anim_player.animation_finished
	player.change_state_to(States.player_states["idle"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	player.look_at(enemy.global_position, Vector3.UP, true)

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	player.in_counter = false
