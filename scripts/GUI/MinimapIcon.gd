extends Node3D
class_name MinimapIcon

enum ICON_TYPE {
	SHOP,
	SCENE,
	DIALOGUE,
	QUEST_MARKER
}

const ICON_TEXTURES: Dictionary = {
	ICON_TYPE.SHOP: preload("res://icon.svg"),
	ICON_TYPE.SCENE: preload("res://icon.svg"),
	ICON_TYPE.DIALOGUE: preload("res://icon.svg"),
	ICON_TYPE.QUEST_MARKER: preload("res://icon.svg"),
}

@onready var icon: Sprite3D = $Icon
