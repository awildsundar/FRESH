extends CharacterBody3D
class_name Enemy

#config vars
@export_category("Config")
@export var anim_player: AnimationPlayer
@export var hitbox: ShapeCast3D
@export var limit_area: Area3D
@export var mesh: Node3D
@export var nav_agent: NavigationAgent3D
@export var lock_on_indicator: Sprite3D

#gameplay vars
@export_category("Gameplay")
@export_group("Stats")
@export var speed: float = 5.0
@export var atk: float = 50.0
@export var def: float = 50.0
@export var hp: float = 100.0
@export_group("Config")
@export_subgroup("Rapid Approach Detection")
@export var approach_speed_threshold: float = 0.0
@export var detection_range: float = 15.0
@export var direct_approach_threshold: float = 0.7
@export_subgroup("Back Away")
@export var attack_distance: float = 100.0
@export var back_away_distance: float = 1.0
@export var back_away_timer: float = 3.0
@export_range(0.1, 1.0, 0.1) var back_away_speed_mult: float = 0.5
@export_subgroup("Circle")
@export var circle_distance: float = 1.0
@export var min_circle_time: float = 1.0
@export var max_circle_time: float = 3.0
@export_range(0.1, 0.9) var attack_chance: float = 0.3
@export_subgroup("Misc")
@export var max_combo: int = 3
@export var rest_time: float = 0.5
@export var shards: int = 5
@export var cash: int = 10

@onready var state_indicator: Label3D = $StateIndicator

var arena_manager: ArenaManager
var state: BaseEnemyState

var combo: int = 0

var target: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arena_manager = self.get_tree().current_scene
	arena_manager.enemies.append(self)
	
	state = States.enemy_states["idle"]
	state.enter(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	state.transition(self)
	state.update(self, delta)
	state_indicator.text = States.enemy_states.find_key(state)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseEnemyState) -> void:
	if state == States.enemy_states["death"]:
		return
	state.exit(self)
	state = next_state
	state.enter(self)

func find_nearest_candidate() -> Node3D:
	var candidates: Array[ArenaCharacter] = arena_manager.characters
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

func hurt(damage: float) -> void:
	if hp > 0.0:
		change_state_to(States.enemy_states["hurt"])
		hp -= damage
