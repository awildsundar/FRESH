extends Node

var story_flags: Dictionary = {}
var act: int = 0

func set_flag(flag: String, value: bool = true) -> void:
	story_flags[flag] = value

func get_flag(flag: String) -> bool:
	return story_flags.get(flag, false)
