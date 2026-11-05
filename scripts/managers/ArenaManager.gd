extends Node3D
class_name ArenaManager

const last_location: Dictionary = {
	ARENA_TYPE.DEFAULT: "uid://blq5h3bovmvqp"
}

enum ARENA_TYPE {
	DEFAULT,
	SPENCER_STREET,
	FLINDERS,
}

@export var starting_character: ArenaCharacter
@export var arena_type: ARENA_TYPE = ARENA_TYPE.DEFAULT
@export var wait_time: float = 3.0
@export var max_synergy: float = 100.0
@export var synergy_timer: float = 3.0

@onready var synergy_bar: ProgressBar = $ArenaUI/Control/MarginContainer/SynergyBar

var characters: Array[ArenaCharacter]

var enemies: Array[Enemy]

var player_hp: float = 0.0
var enemy_shards: int = 0
var enemy_cash: int = 0

var synergy: float = 0.0: 
	set(value):
		if value > max_synergy:
			value = max_synergy
		synergy = value
		synergy_bar.value = synergy

func _ready() -> void:
	synergy_bar.max_value = max_synergy
	
	for player in characters:
		player_hp += player.hp
	
	for enemy in enemies:
		enemy_shards += enemy.shards
		enemy_cash += enemy.cash
	
	change_control_to(starting_character)

func change_control_to(character: ArenaCharacter) -> void:
	for ch in characters:
		if ch == character:
			ch.in_control = true
			ch.rig.camera.make_current()
			ch.change_state_to(States.player_states["idle"])
		else:
			ch.in_control = false
			ch.rig.camera.clear_current()
			ch.change_state_to(States.cpu_states["idle"])
		ch.velocity.y = 0.0
		ch.global_position.y = 0.0

func battle_won() -> void:
	DataManager.shards += enemy_shards
	DataManager.cash += enemy_cash
	
	if QuestManager.get_active_quest_current_step() == 1:
		QuestManager.update_quest()
	
	await get_tree().create_timer(wait_time).timeout
	TransitionManager.load_scene(last_location[arena_type], TransitionManager.LOADING_SCREEN_TYPE.DEFAULT)

func battle_lost() -> void:
	await get_tree().create_timer(wait_time).timeout
	get_tree().quit()
