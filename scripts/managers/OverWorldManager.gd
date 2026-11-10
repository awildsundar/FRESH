extends Node3D
class_name OverWorldManager

enum LOCATION {
	SPENCER_STREET,
	FLINDERS_STREET,
	SOUTHGATE
}

@export var location: LOCATION
@export var main_menu: CanvasLayer
@export var quest: Quest

var current_menu: Menu = null

var enemy_locations: Array[SceneInteractable]
var enemies_visible: bool = false

func _ready() -> void:
	main_menu.hide()
	if QuestManager.active_quest == null:
		QuestManager.start_quest(quest)

func show_enemy_locations() -> void:
	enemies_visible = !enemies_visible
	
	for enemy_location: SceneInteractable in enemy_locations:
		if enemies_visible == true:
			enemy_location.show()
			enemy_location.get_collision_shape().disabled = false
		else:
			enemy_location.hide()
			enemy_location.get_collision_shape().disabled = true
