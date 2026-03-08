extends SpringArm3D

@export_range(0.1, 1.0, 0.1) var sensitivity: float
@export var min_angle: float = -30.0
@export var max_angle: float = 30.0
@export var lock_on_distance: float = 10.0
@export var interact_ray: RayCast3D

@onready var camera: Camera3D = $Camera3D
@onready var camera_pos: Node3D = $"../CameraPos"

var player: CharacterBody3D
var choices_shown: bool = false
var locked_on: bool = false
var current_target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	SignalBus.choice_started.connect(_disable_cam_movement.bind(true))
	SignalBus.choice_finished.connect(_disable_cam_movement.bind(false))

func _physics_process(delta: float) -> void:
	self.global_position = lerp(global_position, camera_pos.global_position, 0.25)
	
	if locked_on && current_target != null:
		_locked_cam()
	else:
		spring_length = lerp(spring_length, 4.0, 0.5)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	
	if event.is_action_pressed("lock_on"):
		locked_on = !locked_on
		if locked_on:
			_set_target(find_nearest_candidate("Enemy"))
		else:
			if current_target != null && current_target is Enemy:
				current_target.lock_on_indicator.hide()
	
	if locked_on:
		if Input.is_action_just_pressed("switch_view_left"):
			switch_target("left", "Enemy")
		elif Input.is_action_just_pressed("switch_view_right"):
			switch_target("right", "Enemy")
	
	if choices_shown == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			rotation_degrees.x -= event.relative.y * sensitivity
			if locked_on == false:
				_free_cam(event)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func find_nearest_candidate(group: String) -> Node3D:
	var candidates: Array[Node] = get_tree().get_nodes_in_group(group)
	var nearest: Node3D = null
	
	for candidate in candidates:
		if is_instance_valid(candidate):
			var dist: float = player.global_position.distance_to(candidate.global_position)
			if dist < lock_on_distance and camera.is_position_in_frustum(candidate.global_position):
				nearest = candidate
	
	return nearest


func switch_target(dir: String, group: String) -> void:
	if not current_target or not camera: return
	
	var candidates: Array[Node] = get_tree().get_nodes_in_group(group)
	var best_candidate: Node3D = null
	var closest_screen_dist: float = INF
	
	var current_screen_pos: Vector2 = camera.unproject_position(current_target.global_position)
	
	for candidate in candidates:
		if candidate == current_target: continue
		if not is_instance_valid(candidate): continue
		
		if player.global_position.distance_to(candidate.global_position) > lock_on_distance: continue
		
		if not camera.is_position_in_frustum(candidate.global_position): continue
		
		var candidate_screen_pos: Vector2 = camera.unproject_position(candidate.global_position)
		
		var diff_x: float = candidate_screen_pos.x - current_screen_pos.x
		var diff_y: float = abs(candidate_screen_pos.y - current_screen_pos.y)
		
		var is_correct_dir: bool = false
		if dir == "right" and diff_x < 0.0: is_correct_dir = true
		if dir == "left" and diff_x > 0.0: is_correct_dir = true
		
		if is_correct_dir:
			var score: float = abs(diff_x) + (diff_y * 2.0)
			
			if score < closest_screen_dist:
				closest_screen_dist = score
				best_candidate = candidate
		
		if best_candidate:
			_set_target(best_candidate)

func _set_target(target: Node3D) -> void:
	if current_target is Enemy:
		current_target.lock_on_indicator.hide()
	current_target = target
	if target is Enemy:
		target.lock_on_indicator.show()

func _free_cam(event: InputEvent) -> void:
	rotation_degrees.y -= event.relative.x * sensitivity
	
	rotation_degrees.x = clampf(rotation_degrees.x, min_angle, max_angle)
	interact_ray.rotation_degrees.x = -rotation_degrees.x

func _locked_cam() -> void:
	spring_length = lerp(spring_length, 3.0, 0.5)
	rotation_degrees.x = clampf(rotation_degrees.x, min_angle/2, max_angle/2)
	
	var look_target: Vector2 = Vector2(current_target.global_position.x, current_target.global_position.z)
	var player_rot: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var dir: Vector2 = -(look_target - player_rot)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.y), 0.25)

func _disable_cam_movement(choice: bool) -> void:
	choices_shown = choice
