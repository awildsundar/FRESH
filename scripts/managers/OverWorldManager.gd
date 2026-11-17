extends Node3D
class_name OverWorldManager

enum LOCATION {
	SPENCER_STREET,
	FLINDERS_STREET,
	SOUTHGATE
}

@export var location: LOCATION
@export var quest: Quest

@onready var enemy_chain_timer: Timer = Timer.new()

var current_menu: Menu = null:
	set(value):
		if value != null:
			player.base_gui.hide()
		else:
			player.base_gui.show()
		current_menu = value
		

var player: OverworldCharacter

var enemy_locations: Array[Arena]
var enemies_visible: bool = false
var enemy_chain_time: float = 3.0

var arena_scene: PackedScene = preload("uid://b7q4webcoivt4")

func _ready() -> void:
	for child in self.get_children():
		if child is OverworldCharacter:
			player = child
	
	if QuestManager.active_quest == null:
		if quest.quest_progression == 0:
			QuestManager.start_quest(quest)
	
	self.add_child(enemy_chain_timer)
	enemy_chain_timer.one_shot = true

func show_enemy_locations() -> void:
	enemies_visible = !enemies_visible
	
	for enemy_location: Arena in enemy_locations:
		if enemies_visible == true:
			enemy_location.enable_interaction(true)
		else:
			enemy_location.enable_interaction(false)
