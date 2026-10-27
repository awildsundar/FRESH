extends Character
class_name ArenaCharacter

signal animation_cancelled

#config vars
@export_category("Config")
@export var mesh_main: Node3D
@export var anim_player: AnimationPlayer
@export var nav_agent: NavigationAgent3D
@export var hitbox: ShapeCast3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var rig: SpringArm3D = $SpringArm3D
@onready var limit_area: Area3D = $LimitArea
#gameplay vars
@export_category("Player")
@export_group("Basics")
@export var speed: float = 10.0
@export var dash_time: float = 0.25
@export var atk: float = 50.0
@export var def: float = 50.0
@export var hp: float = 100.0
@export_group("Combat Config")
@export var buffer_duration: float = 1.25
@export var anim_duration: float = 0.25
@export var max_buffer_size: int = 6
@export_group("Control Config")
@export var in_control: bool = false
@export var control_distance: float = 100.0

#cpu vars
@export_category("CPU")
@export_subgroup("Back Away")
@export var attack_distance: float = 100.0
@export var back_away_distance: float = 1.0
@export var back_away_timer: float = 3.0
@export_range(0.1, 1.0, 0.1) var back_away_speed_mult: float = 0.5
@export_subgroup("Circle")
@export var circle_distance: float = 1.0
@export var min_circle_time: float = 1.0
@export var max_circle_time: float = 3.0
@export_range(0.1, 0.9) var attack_chance: float = 0.3
@export_subgroup("Misc")
@export var max_combo: int = 3

var can_move: bool = true
var input_dir: Vector2
var move_dir: Vector3

var atk_buffer := []
var is_attacking: bool = false
var buffer_input: bool = true

var combo: int = 0

var is_blocking: bool = false

var target: Node3D = null

var arena_manager: ArenaManager
var state: BaseState

func _ready() -> void:
	arena_manager = self.get_tree().current_scene
	arena_manager.characters.append(self)
	
	if in_control:
		state = States.player_states["idle"]
		camera.make_current()
	else:
		state = States.cpu_states["idle"]
		camera.clear_current()
	state.enter(self)

func _unhandled_input(event: InputEvent) -> void:
	if in_control:
		if event.is_action_pressed("dodge"):
			change_state_to(States.player_states["dodge"])
		elif event.is_action_pressed("switch_control"):
			change_state_to(States.player_states["switch"])
		elif event.is_action_pressed("block"):
			change_state_to(States.player_states["block"])
		elif event.is_action_pressed("basic_attack") or event.is_action_pressed("heavy_attack") or event.is_action_pressed("special_attack"):
			if atk_buffer.size() < max_buffer_size && buffer_input == true:
				atk_buffer.append(event.as_text())
			if atk_buffer != [] && is_attacking == false:
				change_state_to(States.player_states["attack"])

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_dir = (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	move_dir = Vector3(move_dir.x, 0, move_dir.z).normalized()
	
	state.transition(self)
	state.update(self, delta)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseState) -> void:
	if state == States.player_states["death"]:
		return
	state.exit(self)
	state = next_state
	state.enter(self)

func enable_control(switch: bool) -> void:
	in_control = switch
	if in_control:
		change_state_to(States.player_states["idle"])
		camera.make_current()
	else:
		change_state_to(States.cpu_states["idle"])
		camera.clear_current()

##Finds the nearest node specified by the group, 0 = enemies, 1 = characters
func find_nearest_candidate(group: int, max_distance: float) -> Node3D:
	var candidates: Array
	
	if group == 0:
		candidates = arena_manager.enemies
	else:
		candidates = arena_manager.characters
	
	var lowest_dist: float = INF
	var nearest: Node3D = null
	
	for candidate in candidates:
		if is_instance_valid(candidate):
			var dist: float = global_position.distance_to(candidate.global_position)
			if dist < max_distance && dist < lowest_dist:
				lowest_dist = dist
				nearest = candidate
	
	target = nearest
	return nearest

##Rotates player mesh based on direction of input
func turn_to(dir: Vector3) -> void:
	if dir:
		var yaw := atan2(dir.x, dir.z)
		yaw = lerp_angle(mesh_main.rotation.y, yaw, 0.25)
		mesh_main.rotation.y = yaw

func cancel() -> void:
	emit_signal("animation_cancelled")

func hurt(damage: float) -> void:
	pass
	if state is BasePlayerState:
		change_state_to(States.player_states["hurt"])
	elif state is BaseCPUState:
		change_state_to(States.cpu_states["hurt"])
	arena_manager.player_hp -= damage
