extends Character
class_name OverworldCharacter

signal animation_cancelled

#config vars
@export_category("Config")
@export var mesh_main: Node3D
@export var interact_ray: RayCast3D
@export var anim_player: AnimationPlayer
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var rig: SpringArm3D = $SpringArm3D

#gameplay vars
@export_category("Gameplay")
@export_group("Basics")
@export var speed: float = 10.0

var can_move: bool = true
var input_dir: Vector2
var move_dir: Vector3

var state: BaseState = States.player_states["idle"]

func _ready() -> void:
	state.enter(self)
	DialogueManager.dialogue_started.connect(enable_movement.bind(false))
	DialogueManager.dialogue_ended.connect(enable_movement.bind(true))

func _unhandled_input(event: InputEvent) -> void:
	if can_move == true:
		if event.is_action_pressed("interact"):
			if interact_ray.is_colliding():
				var collision: Object = interact_ray.get_collider()
				if collision is BaseInteractable:
					change_state_to(States.player_states["idle"])
					collision.interact()

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_dir = (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	move_dir = Vector3(move_dir.x, 0, move_dir.z).normalized()
	
	state.transition(self)
	state.update(self, delta)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseState) -> void:
	state.exit(self)
	state = next_state
	state.enter(self)

##Rotates player mesh based on direction of input
func turn_to(dir: Vector3) -> void:
	if dir:
		var yaw := atan2(dir.x, dir.z)
		yaw = lerp_angle(mesh_main.rotation.y, yaw, 0.25)
		mesh_main.rotation.y = yaw

func enable_movement(_resource: DialogueResource, allowed: bool) -> void:
	can_move = allowed

func cancel() -> void:
	emit_signal("animation_cancelled")
