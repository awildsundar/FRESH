extends CanvasLayer
class_name ShopManager

#Shop Keeper Display nodes
@onready var shop_icon: TextureRect = $Control/MarginContainer/HBoxContainer/ShopKeeperDisplay/VBoxContainer/ShopIcon
@onready var shop_level: Label = $Control/MarginContainer/HBoxContainer/ShopKeeperDisplay/VBoxContainer/ShopLevel

#Stock Display nodes
@onready var stock: GridContainer = $Control/MarginContainer/HBoxContainer/StockDisplay/MarginContainer/ScrollContainer/Stock

#Detail Display nodes
@onready var item_icon: TextureRect = $Control/MarginContainer/HBoxContainer/DetailDisplay/VBoxContainer/ItemIcon
@onready var item_name: RichTextLabel = $Control/MarginContainer/HBoxContainer/DetailDisplay/VBoxContainer/ItemName
@onready var item_description: Label = $Control/MarginContainer/HBoxContainer/DetailDisplay/VBoxContainer/ScrollContainer/ItemDescription
@onready var item_stats: Label = $Control/MarginContainer/HBoxContainer/DetailDisplay/VBoxContainer/ItemStats

var stock_button: PackedScene = preload("uid://dfgh1ensb4r1a")
var shop: Shop
var player: OverworldCharacter

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	player.can_move = false
	
	shop_icon.texture = shop.shop_logo
	shop_level.text = "LVL " + str(shop.level)
	
	item_icon.texture = null
	item_name.text = ""
	item_description.text = ""
	item_stats.text = ""
	
	for item in shop.stock:
		var stock_item: ShopStockButton = stock_button.instantiate()
		stock_item.item = item
		stock_item.shop_manager = self
		stock.add_child(stock_item)

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.can_move = true
	self.queue_free()
