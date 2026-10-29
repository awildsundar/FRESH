extends Node

const SETTINGS_PATH: String = "user://settings.cfg"

var mouse_sensitivity: float = 0.3

func save_settings() -> void:
	var config := ConfigFile.new()
	
	config.set_value("gameplay", "mouse_sensitivity", mouse_sensitivity)
	
	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_error("SettingsManager: Failed to save settings: " + error_string(error))

func load_setttings() -> void:
	var config := ConfigFile.new()
	
	var error := config.load(SETTINGS_PATH)
	
	mouse_sensitivity = config.get_value("gameplay", "mouse_sensitivity")
