extends Resource
class_name SynergyAttack

enum TARGET {
	ENEMIES,
	ALLIES,
	BOTH
}

@export var animation_name: String
@export var status_effect: StatusEffect
@export var target: TARGET = TARGET.ENEMIES
@export var value: float = 5.0
@export var cost: int = 5
@export var unlocked: bool = false

var arena_manager: ArenaManager

func execute_attack() -> void:
	match TARGET:
		TARGET.ENEMIES:
			for enemy in arena_manager.enemies:
				enemy.hurt(arena_manager.active_character, value)
				status_effect.inflict_status_effect(enemy)
		TARGET.ALLIES:
			for ch in arena_manager.characters:
				ch.hp += value
				status_effect.inflict_status_effect(ch)
		TARGET.BOTH:
			for enemy in arena_manager.enemies:
				enemy.hurt(arena_manager.active_character, value)
				status_effect.inflict_status_effect(enemy)
			for ch in arena_manager.characters:
				ch.hp += value
				status_effect.inflict_status_effect(ch)
