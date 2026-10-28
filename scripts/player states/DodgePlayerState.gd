extends BasePlayerState
class_name DodgePlayerState

var move_dir_x: float
var move_dir_z: float

##Runs when state is entered
func enter(player: ArenaCharacter) -> void:
	player.anim_player.play("dodge")
	player.is_invincible = true
	move_dir_x = player.move_dir.x
	move_dir_z = player.move_dir.z
	player.can_move = false

##Runs a frame before update is called, allows for transitions
func transition(player: ArenaCharacter) -> void:
	await player.anim_player.animation_finished
	if player.move_dir == Vector3.ZERO:
		player.change_state_to(States.player_states["idle"])
	else:
		player.change_state_to(States.player_states["move"])

##Runs during a state
func update(player: ArenaCharacter, delta: float) -> void:
	player.velocity.x = move_dir_x * player.speed * 1.2
	player.velocity.z = move_dir_z * player.speed * 1.2

	player.move_and_slide()
	player.turn_to(player.move_dir)

##Runs when state is exited
func exit(player: ArenaCharacter) -> void:
	player.is_invincible = false
	player.can_move = true
