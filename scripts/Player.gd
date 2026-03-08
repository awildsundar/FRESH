extends CharacterBody3D
class_name Character

signal animation_cancelled

#config vars
@export_category("Config")
@export var mesh_main: Node3D
@export var interact_ray: RayCast3D
@export var anim_player: AnimationPlayer
@export var nav_agent: NavigationAgent3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var rig: SpringArm3D = $SpringArm3D

var can_move: bool = true
var input_dir: Vector2
var move_dir: Vector3

var state: BaseCharacterState = States.character_states["idle"]

#gameplay vars
@export_category("Gameplay")
@export var speed: float = 10.0
@export var dash_time: float = 0.25
@export var atk: float = 50.0
@export var def: float = 50.0
@export var hp: float = 100.0

func _ready() -> void:
	state.enter(self)
	SignalBus.timeline_started.connect(enable_movement.bind(false))
	SignalBus.timeline_ended.connect(enable_movement.bind(true))
	
	if get_parent().name == "Arena":
		add_to_group("Character")

func _unhandled_input(event: InputEvent) -> void:
	if can_move == true:
		if event.is_action_pressed("interact"):
			if interact_ray.is_colliding():
				var collision: Object = interact_ray.get_collider()
				if collision is BaseInteractable:
					change_state_to(States.character_states["idle"])
					collision.interact()
		if event.is_action_pressed("attack"):
			change_state_to(States.character_states["attack"])
		if event.is_action_pressed("dash"):
			change_state_to(States.character_states["dash"])

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_dir = (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	move_dir = Vector3(move_dir.x, 0, move_dir.z).normalized()
	
	state.transition(self)
	state.update(self, delta)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseCharacterState) -> void:
	state.exit(self)
	state = next_state
	state.enter(self)

func find_nearest_candidate(group: String, min_distance: float) -> Node3D:
	var candidates: Array[Node] = get_tree().get_nodes_in_group(group)
	var nearest: Node3D = null
	
	for candidate in candidates:
		if is_instance_valid(candidate):
			var dist: float = global_position.distance_to(candidate.global_position)
			if dist < min_distance:
				nearest = candidate
	
	return nearest

##Rotates player mesh based on direction of input
func turn_to(dir: Vector3) -> void:
	if dir:
		var yaw := atan2(dir.x, dir.z)
		yaw = lerp_angle(mesh_main.rotation.y, yaw, 0.25)
		mesh_main.rotation.y = yaw

func enable_movement(allowed: bool) -> void:
	can_move = allowed

func cancel() -> void:
	emit_signal("animation_cancelled")

func damage(body: Node3D) -> void:
	if body is Enemy:
		body.hurt(atk)

func hurt(damage: float) -> void:
	change_state_to(States.character_states["hurt"])
	hp -= damage
