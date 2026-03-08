extends CharacterBody3D
class_name Enemy

#config vars
@export_category("Config")
@export var anim_player: AnimationPlayer
@export var detection_area: Area3D
@export var limit_area: Area3D
@export var mesh: Node3D
@export var nav_agent: NavigationAgent3D
@export var lock_on_indicator: Sprite3D

var state: BaseEnemyState = States.enemy_states["idle"]

#gameplay vars
@export_category("Gameplay")
@export var speed: float = 5.0
@export var atk: float = 50.0
@export var def: float = 50.0
@export var hp: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Enemy")
	state.enter(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	state.transition(self)
	state.update(self, delta)

##Changes the current state and runs the proper functions
func change_state_to(next_state: BaseEnemyState) -> void:
	state.exit(self)
	state = next_state
	state.enter(self)

func find_nearest_candidate(group: String) -> Node3D:
	var candidates: Array[Node] = get_tree().get_nodes_in_group(group)
	var nearest: Node3D = null
	
	for candidate in candidates:
		if is_instance_valid(candidate):
			var dist: float = global_position.distance_to(candidate.global_position)
			if dist < detection_area.get_child(0).shape.size.z:
				nearest = candidate
	
	return nearest

func damage(body: Node3D) -> void:
	if body is Character:
		body.hurt(atk)

func hurt(damage: float) -> void:
	print(damage)
	if state != States.enemy_states["death"]:
		change_state_to(States.enemy_states["hurt"])
		hp -= damage
