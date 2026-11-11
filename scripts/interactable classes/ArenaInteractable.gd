extends Area3D
class_name Arena

@onready var detection_area: Area3D = $DetectionArea
@onready var detection_collision: CollisionShape3D = $DetectionArea/CollisionShape3D
@onready var icon: Sprite3D = $Sprite3D

var arena_scene: PackedScene = preload("uid://b7q4webcoivt4")

var default_position: Vector3


func _ready() -> void:
	var manager: OverWorldManager = get_manager()
	manager.enemy_locations.append(self)
	enable_interaction(false)
	default_position = global_position
	detection_area.body_entered.connect(on_player_detected)
	detection_area.body_exited.connect(on_player_exited)
	body_entered.connect(on_player_entered)

func enable_interaction(toggle: bool) -> void:
	if toggle == true:
		self.show()
		get_collision_shape().disabled = false
		detection_collision.disabled = false
		hover_up()
	else:
		self.hide()
		get_collision_shape().disabled = true
		detection_collision.disabled = true

func on_player_detected(body: Node3D) -> void:
	if body is OverworldCharacter:
		var tween: Tween = create_tween()
		tween.tween_property(self, "global_position", body.global_position + Vector3(0.0, 1.0, 0.0), 2.0)

func on_player_exited(body: Node3D) -> void:
	if body is OverworldCharacter:
		var tween: Tween = create_tween()
		tween.tween_property(self, "global_position", default_position, 2.0)

func on_player_entered(body: Node3D) -> void:
	if body is OverworldCharacter:
		TransitionManager.load_scene(arena_scene.resource_path)

func hover_up() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(icon, "position", icon.position + Vector3(0, 0.5, 0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(hover_down)

func hover_down() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(icon, "position", icon.position + Vector3(0, -0.5, 0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(hover_up)

func get_manager() -> OverWorldManager:
	if self.get_tree().current_scene is OverWorldManager:
		return self.get_tree().current_scene
	return null

func get_collision_shape() -> CollisionShape3D:
	for child in get_children():
		if child is CollisionShape3D:
			return child
	return null
