extends BaseInteractable
class_name ShopInteractable

@export var shop: Shop
@export var animation_name: String = ""

var shop_ui: PackedScene = preload("uid://cmu8rlfgh4hxu")

func _ready() -> void:
	if minimap_icon != null:
		minimap_icon.icon.texture = minimap_icon.ICON_TEXTURES[minimap_icon.ICON_TYPE.SHOP]

func interact() -> void:
	var player: OverworldCharacter = get_player()
	if player.overworld_manager.current_menu == null:
		var ui: ShopManager = shop_ui.instantiate()
		ui.shop = shop
		ui.player = player
		
		if animation_name != "":
			var anim_player: AnimationPlayer = get_animation_player()
			if anim_player.has_animation(animation_name):
				anim_player.play(animation_name)
				await anim_player.animation_finished
			else:
				printerr("ShopInteractable: No animation found!")
		
		self.add_child(ui)
		if QuestManager.get_active_quest_current_step() == 4:
			QuestManager.update_quest()
