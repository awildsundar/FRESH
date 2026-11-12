extends Resource
class_name SpecialAttack

enum TARGET {
	SINGLE,
	AREA,
	CHARACTERS,
	ENEMIES
}

## Determines who the special attack affects, single == one enemy, area == circle surrounding player, rest self explanatory
@export var target: TARGET = TARGET.SINGLE
@export var status_effect: StatusEffect
## Cost in shards
@export var cost: int = 0
@export var animation_name: String
@export var damage: float = 100.0
## Time in seconds
@export var cooldown: float = 1.0
@export var unlocked: bool = false
