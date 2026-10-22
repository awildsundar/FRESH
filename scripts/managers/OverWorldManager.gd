extends Node3D
class_name OverWorldManager

enum LOCATION {
	SPENCER_STREET,
	FLINDERS_STREET,
	SOUTHGATE
}

@export var location: LOCATION
@export var main_menu: CanvasLayer

func _ready() -> void:
	main_menu.hide()
