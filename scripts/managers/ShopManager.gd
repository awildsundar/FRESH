extends Menu
class_name ShopManager

#Shop Keeper Display nodes
@onready var shop_icon: TextureRect = $Control/MarginContainer/HBoxContainer/ShopKeeperDisplay/VBoxContainer/HBoxContainer/ShopIcon
@onready var shop_level: Label = $Control/MarginContainer/HBoxContainer/ShopKeeperDisplay/VBoxContainer/ShopLevel
@onready var shop_keeper_dialogue: Label = $Control/MarginContainer/HBoxContainer/ShopKeeperDisplay/VBoxContainer/MarginContainer/Panel2/ShopKeeperDialogue
@onready var cash_display: Label = $Control/MarginContainer/HBoxContainer/ShopKeeperDisplay/VBoxContainer/HBoxContainer/CashDisplay

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
	player.overworld_manager.current_menu = self
	
	shop_icon.texture = shop.shop_logo
	shop_level.text = "LVL " + str(shop.level)
	shop_keeper_dialogue.text = "Welcome!"
	
	item_icon.texture = null
	item_name.text = ""
	item_description.text = ""
	item_stats.text = ""
	
	shop.progressed.connect(on_progress_changed, shop.level_progression)
	DataManager.cash_updated.connect(cash_changed)
	stock_up()
	cash_changed(DataManager.cash)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_menu"):
		_on_exit_pressed()

func stock_up() -> void:
	for item in stock.get_children():
		item.queue_free()
	
	for item in shop.stock:
		var stock_item: ShopStockButton = stock_button.instantiate()
		stock_item.item = item
		stock_item.shop_manager = self
		stock.add_child(stock_item)

func cash_changed(cash: int) -> void:
	cash_display.text = "CASH: %d" % [cash]

func on_progress_changed(progress: int) -> void:
	if progress == shop.level_requirements.get(shop.level + 1):
		shop.level += 1
		shop_keeper_dialogue.text = "Got some new stuff in stock!"
		shop_level.text = "LVL " + str(shop.level)
		shop.stock.append(shop.level_locked_stock.get(shop.level))
		stock_up()
		progress = 0
	else:
		shop_keeper_dialogue.text = "Thanks for your purchase!"

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.can_move = true
	player.overworld_manager.current_menu = null
	self.queue_free()
