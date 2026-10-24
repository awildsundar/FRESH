extends Menu
class_name MainMenuManager

var overworld_manager: OverWorldManager

func _ready() -> void:
	visibility_changed.connect(toggled)
	overworld_manager = self.get_tree().current_scene
	
func toggled() -> void:
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		overworld_manager.current_menu = self
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		overworld_manager.current_menu = null
