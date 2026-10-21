extends BaseInteractable
class_name ShopInteractable

@export var shop: Shop

var shop_ui: PackedScene = preload("uid://cmu8rlfgh4hxu")

func interact() -> void:
	var player: OverworldCharacter = get_player()
	var ui: ShopManager = shop_ui.instantiate()
	ui.shop = shop
	ui.player = player
	self.add_child(ui)
