extends Node3D
class_name OverWorldManager

enum LOCATION {
	SPENCER_STREET,
	FLINDERS_STREET,
	SOUTHGATE
}

@export var location: LOCATION
@export var quest: Quest

var current_menu: Menu = null

var enemy_locations: Array[Arena]
var enemies_visible: bool = false

func _ready() -> void:
	if QuestManager.active_quest == null:
		if quest.quest_progression == 0:
			QuestManager.start_quest(quest)

func show_enemy_locations() -> void:
	enemies_visible = !enemies_visible
	
	for enemy_location: Arena in enemy_locations:
		if enemies_visible == true:
			enemy_location.enable_interaction(true)
		else:
			enemy_location.enable_interaction(false)
