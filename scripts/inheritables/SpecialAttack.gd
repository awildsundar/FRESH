extends Resource
class_name SpecialAttack

enum MAIN_TARGET {
	SINGLE,
	AREA,
	CHARACTERS,
	ENEMIES
}

## Determines who the special attack affects, single == one enemy, area == circle surrounding player, rest self explanatory
@export var main_target: MAIN_TARGET = MAIN_TARGET.SINGLE
@export var status_effect: StatusEffect
@export var state: String = ""
@export_enum("None", "Archita", "Minnie", "Tom") var character_target: String = "None"
@export var character_status_effect: StatusEffect
## Cost in shards
@export var cost: int = 0
@export var animation_name: String
@export var damage: float = 100.0
## Time in seconds
@export var cooldown: float = 1.0
@export var unlocked: bool = false

var body: CharacterBody3D

func enable_state() -> void:
	if state == "":
		return
	
	if body.in_control == true:
		body.change_state_to(States.player_states[state])
	else:
		body.change_state_to(States.cpu_states[state])
