extends Character
class_name Enemy

signal perfect_block_dodge_possible(value: bool)

#config vars
@export_category("Config")
@export var anim_player: AnimationPlayer
@export var hitbox: ShapeCast3D
@export var limit_area: Area3D
@export var mesh: Node3D
@export var nav_agent: NavigationAgent3D
@export var lock_on_indicator: Sprite3D
@export var counter_indicator: Sprite3D

#gameplay vars
@export_category("Gameplay")
@export var status_effect: StatusEffect
@export_group("Stats")
@export var speed: float = 5.0
@export var base_atk: float = 50.0:
	set(value):
		base_atk = value
		atk = value
@export var base_def: float = 50.0:
	set(value):
		base_def = value
		def = value
@export var base_hp: float = 100.0:
	set(value):
		base_hp = value
		hp = value
@export_group("Config")
@export_subgroup("Back Away")
@export var attack_distance: float = 100.0
@export var back_away_distance: float = 1.0
@export var back_away_timer: float = 3.0
@export_range(0.1, 1.0, 0.1) var back_away_speed_mult: float = 0.5
@export_subgroup("Circle")
@export var circle_distance: float = 1.0
@export var base_min_circle_time: float = 1.0:
	set(value):
		base_min_circle_time = value
		min_circle_time = value
@export var base_max_circle_time: float = 3.0:
	set(value):
		base_max_circle_time = value
		max_circle_time = value
@export_range(0.1, 0.9) var base_attack_chance: float = 0.3:
	set(value):
		base_attack_chance = value
		attack_chance = value
@export_subgroup("Misc")
@export var max_combo: int = 3
@export var rest_time: float = 0.5
@export var shards: int = 5
@export var cash: int = 10

@onready var state_indicator: Label3D = $StateIndicator
@onready var synergy_timer: Timer = Timer.new()
@onready var synergy_visual: ColorRect = $SynergyVisual
@onready var synergy_visual_position: Marker3D = $SynergyVisualPosition

var atk: float
var def: float
var hp: float
var min_circle_time: float
var max_circle_time: float
var attack_chance: float

var arena_manager: ArenaManager
var state: BaseEnemyState

var combo: int = 0
var perfect_bd: bool = false

var status_effects: Array[StatusEffect] = []

var current_attacker: ArenaCharacter:
	set(value):
		if value != current_attacker && value != null:
			attacker_changed = true
		elif value == null:
			attacker_changed = false
		elif value == current_attacker:
			attacker_changed = false
		current_attacker = value

var attacker_changed: bool = false

var target: Node3D = null
var target_list: Array[ArenaCharacter]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arena_manager = self.get_tree().current_scene
	arena_manager.enemies.append(self)
	
	atk = base_atk
	def = base_def
	hp = base_hp
	min_circle_time = base_min_circle_time
	max_circle_time = base_max_circle_time
	attack_chance = base_attack_chance
	
	counter_indicator.hide()
	synergy_visual.hide()
	synergy_timer.one_shot = true
	synergy_timer.timeout.connect(end_synergy_combo)
	add_child(synergy_timer)
	
	state = States.enemy_states["idle"]
	state.enter(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	state.transition(self)
	state.update(self, delta)
	state_indicator.text = States.enemy_states.find_key(state)
	
	if synergy_visual.is_visible_in_tree():
		synergy_visual.position = arena_manager.active_camera.unproject_position(synergy_visual_position.global_position) - synergy_visual.size / 2
		synergy_visual.set_instance_shader_parameter("progress", synergy_timer.time_left / arena_manager.synergy_timer)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseEnemyState) -> void:
	if state == States.enemy_states["death"]:
		return
	state.exit(self)
	state = next_state
	state.enter(self)
	
	if counter_indicator.visible:
		counter_indicator.hide()

func get_state_string() -> StringName:
	var script: Script = state.get_script()
	if script != null:
		var state_name: StringName = script.get_global_name()
		return state_name
	return ""

func find_nearest_candidate(list: Array[ArenaCharacter] = []) -> Node3D:
	var candidates: Array[ArenaCharacter] = list if list != [] else arena_manager.characters
	var lowest_dist: float = INF
	var nearest: Node3D = null
	
	for candidate in candidates:
		if is_instance_valid(candidate):
			var dist: float = global_position.distance_to(candidate.global_position)
			if dist < attack_distance && dist < lowest_dist:
				lowest_dist = dist
				nearest = candidate
	
	target = nearest
	return nearest

func calculate_status_effects() -> void:
	atk = base_atk
	def = base_def
	hp = base_hp
	min_circle_time = base_min_circle_time
	max_circle_time = base_max_circle_time
	attack_chance = base_attack_chance
	
	for status_effect in status_effects:
		match status_effect.affects:
			status_effect.Affects.HEALTH:
				hp *= status_effect.value
			status_effect.Affects.ATTACK:
				atk *= status_effect.value
			status_effect.Affects.DEFENSE:
				def *= status_effect.value
			status_effect.Affects.TIME:
				min_circle_time *= status_effect.value
				max_circle_time *= status_effect.value
			status_effect.Affects.CHANCE:
				attack_chance *= status_effect.value

func erase_status_effect(effect: StatusEffect) -> void:
	status_effects.erase(effect)
	calculate_status_effects()

func start_synergy_combo() -> void:
	if state == States.enemy_states["death"]:
		return
	else:
		synergy_visual.show()
		synergy_timer.start(arena_manager.synergy_timer)

func check_synergy_combo() -> void:
	if synergy_visual.is_visible_in_tree() == false:
		return
	else:
		if attacker_changed == true:
			("attacker changed")
			synergy_visual.hide()
			arena_manager.synergy += 25.0
			arena_manager.synergy_combo_mult += 1.0
			current_attacker = null
			attacker_changed = false

func end_synergy_combo() -> void:
	synergy_visual.hide()
	current_attacker = null
	attacker_changed = false

func perfect_block_dodge(value: bool) -> void:
	perfect_bd = value
	perfect_block_dodge_possible.emit(value)
	
	if value == true:
		counter_indicator.show()
	else:
		counter_indicator.hide()

func hurt(attacker: ArenaCharacter, damage: float) -> void:
	if hp > 0.0:
		change_state_to(States.enemy_states["hurt"])
		hp -= damage
		current_attacker = attacker
		check_synergy_combo()
