extends CharacterBody3D
class_name ArenaCharacter

signal animation_cancelled
signal invincible_toggled(value: bool)

@export var character: CharacterResource
#config vars
@export_category("Nodes")
@export var mesh_main: Node3D
@export var anim_player: AnimationPlayer
@export var nav_agent: NavigationAgent3D
@export var hitbox: ShapeCast3D

@export_group("Combat Config")
@export var buffer_duration: float = 1.25
@export var anim_duration: float = 0.25
@export var max_buffer_size: int = 6
@export var counter_time: float = 2.0
@export var snap_angle: float = 0.7

@export_group("Control Config")
@export var in_control: bool = false
@export var control_distance: float = 100.0

@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var rig: SpringArm3D = $SpringArm3D
@onready var limit_area: Area3D = $LimitArea
@onready var special_attack_timer: Timer = Timer.new()
@onready var animation_cancel_timer: Timer = Timer.new()
@onready var hurtbox: CollisionShape3D = $CollisionShape3D

var speed: float
var atk: float
var def: float
var hp: float
var min_circle_time: float
var max_circle_time: float
var attack_chance: float

var can_move: bool = true
var input_dir: Vector2
var move_dir: Vector3
var animation_cancel_time: float = 0.2

var atk_buffer := []
var is_attacking: bool = false
var buffer_input: bool = true

var combo: int = 0

var is_invincible: bool = false
var state_switchable: bool = true
var in_counter: bool = false

var target: Node3D = null

var status_effects: Array[StatusEffect] = []

var arena_manager: ArenaManager
var state: BaseState

func _ready() -> void:
	arena_manager = self.get_tree().current_scene
	arena_manager.characters.append(self)
	
	speed = character.base_speed
	atk = character.base_atk
	def = character.base_def
	hp = character.base_hp
	min_circle_time = character.base_min_circle_time
	max_circle_time = character.base_max_circle_time
	attack_chance = character.base_attack_chance
	
	special_attack_timer.one_shot = true
	add_child(special_attack_timer)
	
	animation_cancel_timer.one_shot = true
	add_child(animation_cancel_timer)
	
	if in_control == true:
		state = States.player_states["idle"]
	else:
		state = States.cpu_states["idle"]
	
	state.enter(self)

func _unhandled_input(event: InputEvent) -> void:
	if in_control:
		if event.is_action_pressed("dodge"):
			can_move = true
			change_state_to(States.player_states["dodge"])
		elif event.is_action_pressed("switch_control"):
			change_state_to(States.player_states["switch"])
		elif event.is_action_pressed("block"):
			change_state_to(States.player_states["block"])
		elif event.is_action_pressed("basic_attack"):
			if in_counter == false:
				if atk_buffer.size() < max_buffer_size && buffer_input == true:
					atk_buffer.append(event)
				if atk_buffer != [] && is_attacking == false:
					change_state_to(States.player_states["attack"])
		elif event.is_action_pressed("special_attack"):
			if special_attack_timer.is_stopped() == true or special_attack_timer.time_left <= 0.0:
				atk_buffer = []
				change_state_to(States.player_states["special_attack"])
		elif event.is_action_pressed("synergy_attack"):
			if arena_manager.synergy == arena_manager.max_synergy:
				if in_control:
					change_state_to(States.player_states["synergy_attack"])
				else:
					change_state_to(States.cpu_states["synergy_attack"])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("leave_battle"):
		arena_manager.escape_arena_ui.show()
		Engine.time_scale = 0.0
		can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

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
		var enemy: Enemy = find_nearest_candidate(0, character.attack_distance)
		if enemy != null:
			if enemy.perfect_bd == true:
				state_switchable = true
				change_state_to(States.player_states["counter"])

func calculate_status_effects() -> void:
	speed = character.base_speed
	atk = character.base_atk
	def = character.base_def
	hp = character.base_hp
	min_circle_time = character.base_min_circle_time
	max_circle_time = character.base_max_circle_time
	attack_chance = character.base_attack_chance
	
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
