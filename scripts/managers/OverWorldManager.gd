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

func _ready() -> void:
	main_menu.hide()
	if QuestManager.active_quest == null:
		QuestManager.start_quest(quest)
