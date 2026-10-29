extends SpringArm3D

@export var spring_distance: float = 4.0
@export var min_angle: float = -30.0
@export var max_angle: float = 30.0
@export var lock_on_distance: float = 10.0

@onready var camera: Camera3D = $Camera3D
@onready var camera_pos: Node3D = $"../CameraPos"

var sensitivity: float

var player: Character
var locked_on: bool = false
var current_target: Node3D
var initial_global_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sensitivity = SettingsManager.mouse_sensitivity
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent()
	add_excluded_object(player)
	initial_global_position = self.global_position

func _physics_process(delta: float) -> void:
	self.global_position = lerp(global_position, camera_pos.global_position, 0.25)
	
	if player.state == States.player_states["switch"]:
		spring_length = lerp(spring_length, 1.0, 0.5)
	else:
		spring_length = lerp(spring_length, spring_distance, 0.5)
	
	if locked_on == true && is_instance_valid(current_target):
		_locked_cam()
	else:
		spring_length = lerp(spring_length, spring_distance, 0.5)
		locked_on = false
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	
	if event.is_action_pressed("lock_on") && player is ArenaCharacter:
		locked_on = !locked_on
		var enemy: Node3D = find_nearest_candidate()
		if locked_on and enemy != null:
			_set_target(enemy)
		else:
			locked_on = false

	if locked_on:
		if Input.is_action_just_pressed("switch_view_left"):
			switch_target("left")
		elif Input.is_action_just_pressed("switch_view_right"):
			switch_target("right")
	else:
		if is_instance_valid(current_target):
			current_target.lock_on_indicator.hide()
		
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * sensitivity
		if locked_on == false:
			_free_cam(event)

func find_nearest_candidate() -> Node3D:
	var candidates: Array = player.arena_manager.enemies
	var nearest: Node3D = null
	
	for unwanted_candidate in candidates:
		if unwanted_candidate.state == States.enemy_states["death"]:
			candidates.erase(unwanted_candidate)
	
	for candidate in candidates:
		if is_instance_valid(candidate) and candidate.is_queued_for_deletion() == false:
			var dist: float = player.global_position.distance_to(candidate.global_position)
			if dist < lock_on_distance and camera.is_position_in_frustum(candidate.global_position):
				nearest = candidate
	
	return nearest


func switch_target(dir: String) -> void:
	if not current_target or not camera: return
	
	var candidates: Array = player.arena_manager.enemies
	var best_candidate: Node3D = null
	var closest_screen_dist: float = INF
	
	var current_screen_pos: Vector2 = camera.unproject_position(current_target.global_position)
	
	for candidate in candidates:
		if candidate == current_target: continue
		if not is_instance_valid(candidate): continue
		if candidate.hp <= 0.0: continue
		
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
		
		if is_instance_valid(best_candidate):
			_set_target(best_candidate)

func _set_target(target: Node3D) -> void:
	if is_instance_valid(current_target):
		current_target.lock_on_indicator.hide()
	current_target = target
	target.lock_on_indicator.show()

func _free_cam(event: InputEvent) -> void:
	rotation_degrees.y -= event.relative.x * sensitivity
	
	rotation_degrees.x = clampf(rotation_degrees.x, min_angle, max_angle)

func _locked_cam() -> void:
	spring_length = lerp(spring_length, 3.0, 0.5)
	rotation_degrees.x = clampf(rotation_degrees.x, min_angle/2, max_angle/2)
	
	var look_target: Vector2 = Vector2(current_target.global_position.x, current_target.global_position.z)
	var player_rot: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var dir: Vector2 = -(look_target - player_rot)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.y), 0.25)
