extends BaseInteractable
class_name UpgradeInteractable

@export var animation_name: String = ""

var upgrade_ui: PackedScene = preload("res://scenes/UI/UpgradeUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if minimap_icon != null:
		minimap_icon.icon.texture = minimap_icon.ICON_TEXTURES[minimap_icon.ICON_TYPE.SHOP]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact() -> void:
	var player: OverworldCharacter = get_player()
	if player.overworld_manager.current_menu == null:
		var ui: UpgradeManager = upgrade_ui.instantiate()
		ui.player = player
		
		if animation_name != "":
			var anim_player: AnimationPlayer = get_animation_player()
			if anim_player.has_animation(animation_name):
				anim_player.play(animation_name)
				await anim_player.animation_finished
			else:
				printerr("UpgradeInteractable: No animation found!")
		
		self.add_child(ui)
