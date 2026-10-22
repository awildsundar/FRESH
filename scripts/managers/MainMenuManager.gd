extends CanvasLayer
class_name MainMenuManager

func _ready() -> void:
	visibility_changed.connect(toggled)
	
func toggled() -> void:
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
