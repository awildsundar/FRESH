extends Node3D
class_name ArenaManager

enum ARENA_TYPE {
	DEFAULT,
	SPENCER_STREET,
	FLINDERS,
}

@export var arena_type: ARENA_TYPE = ARENA_TYPE.DEFAULT
@export var wait_time: float = 3.0

var characters: Array[Character]
var enemies: Array[Enemy]

var player_hp: float = 0.0
var enemy_shards: int = 0

var last_location: Dictionary = {
	ARENA_TYPE.DEFAULT: "uid://blq5h3bovmvqp"
}

func _ready() -> void:
	for player in characters:
		player_hp += player.hp
	print(player_hp)
	
	for enemy in enemies:
		enemy_shards += enemy.shards

func battle_won() -> void:
	DataManager.cash += (enemy_shards * 10)
	await get_tree().create_timer(wait_time).timeout
	TransitionManager.load_scene(last_location[arena_type], TransitionManager.LOADING_SCREEN_TYPE.DEFAULT)

func battle_lost() -> void:
	await get_tree().create_timer(wait_time).timeout
	get_tree().quit()
