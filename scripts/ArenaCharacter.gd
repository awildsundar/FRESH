extends Character
class_name ArenaCharacter

signal animation_cancelled
signal invincible_toggled(value: bool)

#config vars
@export_category("Config")
@export var mesh_main: Node3D
@export var anim_player: AnimationPlayer
@export var nav_agent: NavigationAgent3D
@export var hitbox: ShapeCast3D
#gameplay vars
@export_category("Player")
@export_group("Basics")
@export var speed: float = 10.0
@export var dash_time: float = 0.25
@export var base_atk: float = 50.0:
	set(value):
		base_atk = value
		atk = value
@export var base_def: float = 50.0:
	set(value):
		base_def = value
		def = value
@export var base_hp: float = 100.0:
	set(value):
		base_hp = value
		hp = value
@export_group("Combat Config")
@export var attack_distance: float = 100.0
@export var buffer_duration: float = 1.25
@export var anim_duration: float = 0.25
@export var max_buffer_size: int = 6
@export var counter_time: float = 2.0
@export_group("Control Config")
@export var in_control: bool = false
@export var control_distance: float = 100.0

#cpu vars
@export_category("CPU")
@export_subgroup("Back Away")
@export var back_away_distance: float = 1.0
@export var back_away_timer: float = 3.0
@export_range(0.1, 1.0, 0.1) var back_away_speed_mult: float = 0.5
@export_subgroup("Circle")
@export var circle_distance: float = 1.0
@export var base_min_circle_time: float = 1.0:
	set(value):
		base_min_circle_time = value
		min_circle_time = value
@export var base_max_circle_time: float = 3.0:
	set(value):
		base_max_circle_time = value
		max_circle_time = value
@export_range(0.1, 0.9) var base_attack_chance: float = 0.3:
	set(value):
		base_attack_chance = value
		attack_chance = value
@export_subgroup("Misc")
@export var max_combo: int = 3

@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var rig: SpringArm3D = $SpringArm3D
@onready var limit_area: Area3D = $LimitArea

var can_move: bool = true
var input_dir: Vector2
var move_dir: Vector3

var atk_buffer := []
var is_attacking: bool = false
var buffer_input: bool = true

var combo: int = 0

var is_invincible: bool = false
var state_switchable: bool = true
var in_counter: bool = false

var target: Node3D = null

var atk: float
var def: float
var hp: float
var min_circle_time: float
var max_circle_time: float
var attack_chance: float

var status_effects: Array[StatusEffect] = []

var arena_manager: ArenaManager
var state: BaseState

func _ready() -> void:
	arena_manager = self.get_tree().current_scene
	arena_manager.characters.append(self)
	
	atk = base_atk
	def = base_def
	hp = base_hp
	min_circle_time = base_min_circle_time
	max_circle_time = base_max_circle_time
	attack_chance = base_attack_chance
	
	if in_control == true:
		state = States.player_states["idle"]
	else:
		state = States.cpu_states["idle"]
	
	state.enter(self)

func _unhandled_input(event: InputEvent) -> void:
	if in_control:
		if event.is_action_pressed("dodge"):
			change_state_to(States.player_states["dodge"])
		elif event.is_action_pressed("switch_control"):
			change_state_to(States.player_states["switch"])
		elif event.is_action_pressed("block"):
			change_state_to(States.player_states["block"])
		elif event.is_action_pressed("basic_attack") or event.is_action_pressed("special_attack"):
			if in_counter == false:
				if atk_buffer.size() < max_buffer_size && buffer_input == true:
					atk_buffer.append(event)
				if atk_buffer != [] && is_attacking == false:
					change_state_to(States.player_states["attack"])
		elif event.is_action_pressed("synergy_attack"):
			if arena_manager.synergy == arena_manager.max_synergy:
				for enemy in arena_manager.enemies:
					enemy.hurt(self, 5.0)
				arena_manager.synergy = 0.0

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if can_move == true && in_control == true:
		move_dir = (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
		move_dir = Vector3(move_dir.x, 0, move_dir.z).normalized()
	
	state.transition(self)
	state.update(self, delta)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseState) -> void:
	if state_switchable == false:
		return
	
	state.exit(self)
	
	if in_control == true:
		if state is BasePlayerState && next_state is BasePlayerState:
			state = next_state
		else:
			state = States.player_states["idle"]
	else:
		if state is BaseCPUState && next_state is BaseCPUState:
			state = next_state
		else:
			state = States.cpu_states["idle"]
	
	state.enter(self)

func get_state_string() -> StringName:
	var script: Script = state.get_script()
	if script != null:
		var state_name: StringName = script.get_global_name()
		return state_name
	return ""

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
		yaw = lerp_angle(rotation.y, yaw, 0.25)
		rotation.y = yaw

func cancel() -> void:
	emit_signal("animation_cancelled")

func invincible(value: bool) -> void:
	is_invincible = value
	invincible_toggled.emit(value)
	
	# Checks if it was a perfect block/dodge
	if value == true:
		var enemy: Enemy = find_nearest_candidate(0, attack_distance)
		if enemy != null:
			if enemy.perfect_bd == true:
				state_switchable = true
				change_state_to(States.player_states["counter"])

func calculate_status_effects() -> void:
	atk = base_atk
	def = base_def
	hp = base_hp
	min_circle_time = base_min_circle_time
	max_circle_time = base_max_circle_time
	attack_chance = base_attack_chance
	
	for status_effect in status_effects:
		match status_effect.affects:
			status_effect.Affects.HEALTH:
				hp *= status_effect.value
			status_effect.Affects.ATTACK:
				atk *= status_effect.value
			status_effect.Affects.DEFENSE:
				def *= status_effect.value
			status_effect.Affects.TIME:
				min_circle_time *= status_effect.value
				max_circle_time *= status_effect.value
			status_effect.Affects.CHANCE:
				attack_chance *= status_effect.value
	print(def)

func erase_status_effect(effect: StatusEffect) -> void:
	status_effects.erase(effect)
	calculate_status_effects()

func hurt(damage: float) -> void:
	if is_invincible == false:
		if state is BasePlayerState:
			change_state_to(States.player_states["hurt"])
		elif state is BaseCPUState:
			change_state_to(States.cpu_states["hurt"])
		arena_manager.player_hp -= damage
