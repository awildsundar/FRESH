extends Resource
class_name StatusEffect

enum Affects {
	HEALTH,
	ATTACK,
	DEFENSE,
	TIME,
	CHANCE
}

@export var effect_name: String
@export var affects: Affects
## value expressed as a decimal from 0 to 3
@export_range(0.0, 3.0, 0.01) var value: float = 0.0
@export var affect_time: float = 5.0
@export var inflicts_state: bool = false
@export var state: String = "":
	set(value):
		state = value
		if value == "":
			inflicts_state = false

func inflict_status_effect(body: Variant) -> void:
	if body is not Character and body is not Enemy:
		return
	
	body.status_effects.append(self)
	var timer: SceneTreeTimer = body.get_tree().create_timer(affect_time)
	timer.connect("timeout", body.erase_status_effect.bind(self))

	if inflicts_state == true:
		if body is Enemy:
			body.change_state_to(States.enemy_states[state])
		elif body is Character:
			if body.in_control == true:
				body.change_state_to(States.player_states[state])
			else:
				body.change_state_to(States.cpu_states[state])
	
	body.calculate_status_effects()
