extends Node

signal saving_game
signal game_saved(slot: int)
signal game_loaded(slot: int)

const SAVE_DIR: String = "user://save_files/"
const MAX_SLOTS: int = 3
const FILE_EXTENSION: String = ".res"

var save_data: Dictionary = {}

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

func save_game(slot: int) -> void:
	saving_game.emit()
	var data: SaveData = DataManager.store_data_to_resource()
	
	var error: Error = ResourceSaver.save(data, _get_path(slot))
	
	if error != OK:
		push_error("SaveManager: failed to save resource: " + error_string(error))

	game_saved.emit(slot)

func load_game(slot: int) -> bool:
	var path := _get_path(slot)
	
	if not ResourceLoader.exists(path):
		push_warning("SaveManager: No save file found at " + path)
		return false
	
	var data: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	
	if not data is SaveData:
		push_error("SaveManager: Save at " + path + " is not a valid SaveData path.")
		return false
	elif data == null:
		push_error("SaveManager: Save at " + path + " is not a valid SaveData resource.")
		return false
	
	DataManager.load_data_from_resource(data)
	game_loaded.emit(slot)
	return true
	
	
func has_save(slot: int) -> bool:
	return FileAccess.file_exists(_get_path(slot))

func get_save_info(slot: int) -> Dictionary:
	var path := _get_path(slot)
	if ResourceLoader.exists(path):
		var data: Resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if data != null && data is SaveData:
			return {"story_act": data.story_act, "timestamp": data.timestamp}
	return {}

func delete_save(slot: int) -> void:
	var path := _get_path(slot)
	if ResourceLoader.exists(path):
		DirAccess.remove_absolute(path)

func _get_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d%s" % [slot, FILE_EXTENSION]
