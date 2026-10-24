extends Node
class_name RapidApproachDetector

signal rapid_approach_detected
signal approach_ended

@onready var enemy: Enemy = self.get_parent()
@onready var characters: Array[ArenaCharacter] = self.get_tree().current_scene.characters

var _is_approaching: bool = false

func _physics_process(delta: float) -> void:
	if not characters or not enemy:
		return
	
	var was_approaching: bool = _is_approaching
	_is_approaching = check_rapid_approach()
	
	if _is_approaching and not was_approaching:
		rapid_approach_detected.emit()
		print("approaching")
	elif not _is_approaching and was_approaching:
		approach_ended.emit()
		print("gone")

func check_rapid_approach() -> bool:
	var to_enemy: Vector3
	
	var distance: float = return_closest_character()[1]
	var character: ArenaCharacter = return_closest_character()[0]
	
	if distance > enemy.detection_range:
		return false
	var character_speed: float = character.velocity.length()
	if character_speed < enemy.approach_speed_threshold:
		return false
	
	var dir_to_enemy: Vector3 = to_enemy.normalized()
	var approach_dot: float = character.velocity.normalized().dot(dir_to_enemy)
	return approach_dot > enemy.direct_approach_threshold

func return_closest_character() -> Array:
	var last_dist: float = INF
	var closest_character: ArenaCharacter = null
	
	for ch in characters:
		var dist_v3: Vector3 = enemy.global_position - ch.global_position
		var dist: float = dist_v3.length()
		if dist < last_dist:
			last_dist = dist
			closest_character = ch
	return [closest_character, last_dist]
