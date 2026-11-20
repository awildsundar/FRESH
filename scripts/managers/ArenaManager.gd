extends Node3D
class_name ArenaManager

const last_location: Dictionary = {
	DataManager.LOCATION.FLINDERS_STREET: "uid://blq5h3bovmvqp",
	DataManager.LOCATION.SPENCER_STREET: "uid://db02wftp23qin"
}

enum ENEMY_TYPE {
	BASIC,
	FLIGHT,
	MIND
}

@export var enemy_count: Dictionary[int, Array] = {}
@export var wave_number: int = 1
@export var starting_character: CharacterResource
@export var character_spawn: Node3D
@export var enemy_spawn: NavigationRegion3D
@export var enemy_type: ENEMY_TYPE = ENEMY_TYPE.BASIC
@export var wait_time: float = 3.0
@export var synergy_timer: float = 3.0

@onready var score_manager: ScoreManager = $ScoreManager

@onready var synergy_bar: ProgressBar = $ContextArenaUI/Context/MarginContainer/SynergyBar
@onready var synergy_combo_time: float = 2.0
@onready var synergy_combo_timer: Timer = Timer.new()

@onready var escape_arena_ui: CanvasLayer = $EscapeArenaUI
@onready var elapsed_time_display: Label = $ContextArenaUI/Context/MarginContainer2/ElapsedTime
@onready var arena_floor: CSGBox3D = $Enemies/floor

const character_scene = preload("uid://cy7q15dradsep")
const enemy_scene = preload("uid://c6ldg60vhftek")

var characters: Array[ArenaCharacter]
var active_character: ArenaCharacter

var synergy_attack: SynergyAttack

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
		
		if value == 5.0:
			score_manager.synergy_multipler_activations += 1
		
		if value != 1.0:
			synergy_combo_timer.start(synergy_combo_time)

func _ready() -> void:
	escape_arena_ui.hide()
	
	synergy_attack = DataManager.synergy_attack
	synergy_attack.arena_manager = self
	
	for character in DataManager.unlocked_characters:
		var ch: ArenaCharacter = character_scene.instantiate()
		ch.character = character
		score_manager.character_attacks_count.set(character, 0)
		character_spawn.add_child(ch)
		ch.global_position = Vector3(randf_range(-arena_floor.size.x / 2, arena_floor.size.x / 2), 0.0, randf_range(-arena_floor.size.z / 2, arena_floor.size.z / 2))
		if DataManager.starting_buff != null:
			DataManager.starting_buff.inflict_status_effect(ch)
	
	enemy_count = DataManager.arena_enemy_count
	
	if DataManager.arena_enemy_count == {}:
		enemy_count = {
			1: [preload("res://resources/entities/enemies/Test.tres")]}
	
	for i in enemy_count.get(wave_number):
		var enemy: Enemy = enemy_scene.instantiate()
		enemy.enemy = i
		enemy_spawn.add_child(enemy)
		enemy.global_position = Vector3(randf_range(-arena_floor.size.x / 2, arena_floor.size.x / 2), 0.0, randf_range(-arena_floor.size.z / 2, arena_floor.size.z / 2))
	
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

func _process(delta: float) -> void:
	var ms: int = int(score_manager.elapsed_time) % 1000
	var total_seconds: int = int(score_manager.elapsed_time / 1000.0)
	var seconds: int = total_seconds % 60
	var minutes: int = int(total_seconds / 60.0)
	
	elapsed_time_display.text = "%02d:%02d.%03d" % [minutes, seconds, ms]

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
	await get_tree().create_timer(wait_time).timeout
	
	if wave_number == enemy_count.keys().back():
		DataManager.arena_enemy_count = {}
		wave_number = 1
		DataManager.shards += enemy_shards
		DataManager.cash += enemy_cash
		score_manager.battle_ended()
		TransitionManager.load_scene(last_location[DataManager.last_location], TransitionManager.LOADING_SCREEN_TYPE.DEFAULT)
	else:
		wave_number += 1
		for i in enemy_count.get(wave_number):
			var enemy: Enemy = enemy_scene.instantiate()
			enemy.enemy = i
			enemy_spawn.add_child(enemy)
			enemies.append(enemy)
			enemy_shards += enemy.enemy.shards
			enemy_cash += enemy.enemy.cash
			enemy.global_position = Vector3(randf_range(-arena_floor.size.x / 2, arena_floor.size.x / 2), 0.0, randf_range(-arena_floor.size.z / 2, arena_floor.size.z / 2))

func battle_lost() -> void:
	await get_tree().create_timer(wait_time).timeout
	DataManager.arena_enemy_count = {}
	wave_number = 1
	get_tree().quit()

func _on_continue_pressed() -> void:
	escape_arena_ui.hide()
	Engine.time_scale = 1.0
	active_character.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_escape_pressed() -> void:
	Engine.time_scale = 1.0
	TransitionManager.load_scene(last_location[DataManager.last_location], TransitionManager.LOADING_SCREEN_TYPE.DEFAULT)
