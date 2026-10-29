extends Node

signal inventory_updated
signal shards_updated(value: int)
signal cash_updated(value: int)

const KEYS: Array = [
	"cash",
	"shards",
	"inventory",
	"arena_entered",
	"story_flags",
	"story_act",
	"timestamp",
	"save_version"
]

const RESET: Dictionary = {
	KEYS[0]: 0,
	KEYS[1]: 0,
	KEYS[2]: {},
	KEYS[3]: false,
	KEYS[4]: {},
	KEYS[5]: 0
}

const CURRENT_SAVE_VERSION: int = 1

var cash: int:
	set(value):
		cash = value
		cash_updated.emit(value)
var shards: int:
	set(value):
		shards = value
		shards_updated.emit(value)
var inventory: Dictionary[Item, int]
var arena_entered: bool = false

var story_flags: Dictionary = {}
var story_act: int = 0

var save_data: Dictionary

func set_flag(flag: String, value: bool = true) -> void:
	story_flags[flag] = value

func get_flag(flag: String) -> bool:
	return story_flags.get(flag, false)

func reset_data() -> void:
	cash = RESET["cash"]
	shards = RESET["shards"]
	inventory = RESET["inventory"]
	arena_entered = RESET["arena_entered"]
	story_flags = RESET["story_flags"]
	story_act = RESET["story_act"]

func store_data_to_dict() -> Dictionary:
	return {
	KEYS[0]: cash,
	KEYS[1]: shards,
	KEYS[2]: inventory,
	KEYS[3]: arena_entered,
	KEYS[4]: story_flags,
	KEYS[5]: story_act,
	KEYS[6]: Time.get_datetime_string_from_system(),
	KEYS[7]: CURRENT_SAVE_VERSION
	}

func load_data_from_dict(data: Dictionary) -> void:
	cash = data.get(KEYS[0], RESET[KEYS[0]])
	shards = data.get(KEYS[1], RESET[KEYS[1]])
	inventory = data.get(KEYS[2], RESET[KEYS[2]])
	arena_entered = data.get(KEYS[3], RESET[KEYS[3]])
	story_flags = data.get(KEYS[4], RESET[KEYS[4]])
	story_act = data.get(KEYS[5], RESET[KEYS[5]])
