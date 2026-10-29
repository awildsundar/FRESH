extends Node

signal game_saved(slot: int)
signal game_loaded(slot: int)

const SAVE_DIR: String = "user://save_files/"
const MAX_SLOTS: int = 3
const FILE_EXTENSION: String = ".dat"

var save_data: Dictionary = {}

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

func save_game(slot: int) -> void:
	var data: Dictionary = DataManager.store_data_to_dict()
	
	var file := FileAccess.open(_get_path(slot), FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: Failed to open file for writing: " + error_string(FileAccess.get_open_error()))
		return
	
	file.store_var(data)
	game_saved.emit(slot)

func load_game(slot: int) -> bool:
	var path := _get_path(slot)
	
	if not FileAccess.file_exists(path):
		push_warning("SaveManager: No save file found at: " + path)
		return false
	
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("SaveManager: Failed to open file for reading: " + error_string(FileAccess.get_open_error()))
		return false
	
	var data: Variant = file.get_var()
	if not data is Dictionary:
		push_error("SaveManager: Save file does not contain valid dictionary: " + path)
		return false
	
	DataManager.load_data_from_dict(data)
	game_loaded.emit(slot)
	return true
	
	
func has_save(slot: int) -> bool:
	return FileAccess.file_exists(_get_path(slot))

func get_save_info(slot: int) -> Dictionary:
	var path := _get_path(slot)
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			var data: Variant = file.get_var()
			if data is Dictionary:
				return {"story_act": data.get("story_act"), "timestamp": data.get("timestamp", "")}
	return {}

func delete_save(slot: int) -> void:
	var path := _get_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func _get_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d%s" % [slot, FILE_EXTENSION]
