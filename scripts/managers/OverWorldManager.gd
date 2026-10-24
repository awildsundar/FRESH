extends Node3D
class_name OverWorldManager

enum LOCATION {
	SPENCER_STREET,
	FLINDERS_STREET,
	SOUTHGATE
}

@export var location: LOCATION
@export var main_menu: CanvasLayer

var current_menu: Menu = null

func _ready() -> void:
	main_menu.hide()
