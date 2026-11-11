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

enum ENEMY_TYPE {
	BASIC,
	FLIGHT,
	MIND
}

@export var starting_character: CharacterResource
@export var character_spawn: Node3D
@export var enemy_spawn: NavigationRegion3D
@export var arena_type: ARENA_TYPE = ARENA_TYPE.DEFAULT
@export var enemy_type: ENEMY_TYPE = ENEMY_TYPE.BASIC
@export var enemy_count: int = 3
@export var wait_time: float = 3.0
@export var synergy_timer: float = 3.0

@onready var synergy_bar: ProgressBar = $ContextArenaUI/Context/MarginContainer/SynergyBar
@onready var synergy_combo_time: float = 2.0
@onready var synergy_combo_timer: Timer = Timer.new()

@onready var escape_arena_ui: CanvasLayer = $EscapeArenaUI
@onready var floor: CSGBox3D = $Enemies/floor

const character_scene = preload("uid://cy7q15dradsep")
const enemy_scene = preload("uid://c6ldg60vhftek")

var characters: Array[ArenaCharacter]
var active_character: ArenaCharacter

var enemies: Array[Enemy]

var player_hp: float = 0.0
var enemy_shards: int = 0
var enemy_cash: int = 0

var active_camera: Camera3D

var max_synergy: float = -100.0
var synergy: float = 0.0: 
	set(value):
		if value > max_synergy:
			value = max_synergy
		synergy = value
		synergy_bar.value = synergy
var synergy_combo_mult: float = 1.0:
	set(value):
		if value > 5.0:
			value = 5.0
		synergy_combo_mult = value
		if value != 1.0:
			synergy_combo_timer.start(synergy_combo_time)

func _ready() -> void:
	escape_arena_ui.hide()
	
	for i in DataManager.unlocked_characters:
		var ch: ArenaCharacter = character_scene.instantiate()
		character_spawn.add_child(ch)
		ch.global_position = Vector3(randf_range(-floor.size.x / 2, floor.size.x / 2), 0.0, randf_range(-floor.size.z / 2, floor.size.z / 2))
	
	for i in enemy_count:
		var enemy: Enemy = enemy_scene.instantiate()
		enemy_spawn.add_child(enemy)
		enemy.global_position = Vector3(randf_range(-floor.size.x / 2, floor.size.x / 2), 0.0, randf_range(-floor.size.z / 2, floor.size.z / 2))
	
	for player in characters:
		player_hp += player.hp
		max_synergy += 100.0
	
	synergy_bar.max_value = max_synergy
	synergy_combo_timer.one_shot = true
	synergy_combo_timer.timeout.connect(reset_synergy_combo_mult)
	add_child(synergy_combo_timer)
	
	for enemy in enemies:
		enemy_shards += enemy.enemy.shards
		enemy_cash += enemy.enemy.cash
	
	var control_ch: ArenaCharacter
	for ch in characters:
		if ch.character == starting_character:
			control_ch = ch
			break
	
	change_control_to(control_ch)

func reset_synergy_combo_mult() -> void:
	synergy_combo_mult = 1.0

func change_control_to(character: ArenaCharacter) -> void:
	for ch in characters:
		if ch == character:
			ch.in_control = true
			ch.rig.camera.make_current()
			active_character = ch
			active_camera = ch.rig.camera
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

func _on_continue_pressed() -> void:
	escape_arena_ui.hide()
	Engine.time_scale = 1.0
	active_character.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_escape_pressed() -> void:
	Engine.time_scale = 1.0
	TransitionManager.load_scene(last_location[arena_type], TransitionManager.LOADING_SCREEN_TYPE.DEFAULT)
