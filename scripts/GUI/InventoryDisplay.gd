extends Control
class_name InventoryDisplay



@onready var shards_cash_display: Label = $Panel/MarginContainer/VBoxContainer/ShardsCashDisplay
@onready var inventory_display: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/InventoryDisplay

func _ready() -> void:
	shards_cash_display.text = "SHARDS: %d CASH: %d" % [DataManager.shards, DataManager.cash]
	DataManager.connect("inventory_updated", inventory_updated)
	DataManager.connect("shards_updated", shards_cash_updated)
	DataManager.connect("cash_updated", shards_cash_updated)

func inventory_updated() -> void:
	for child in inventory_display.get_children():
		child.queue_free()
	
	for item: Item in DataManager.inventory.keys():
		var item_display: Button = Button.new()
		item_display.icon = item.icon
		if DataManager.inventory[item] > 1:
			item_display.text = "%s x%d" % [item.item_name, DataManager.inventory[item]]
		else:
			item_display.text = item.item_name
		
		item_display.alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_display.add_theme_font_size_override("font_size", 40)
		
		inventory_display.add_child(item_display)

func shards_cash_updated(_value: int) -> void:
	shards_cash_display.text = "SHARDS: %d CASH: %d" % [DataManager.shards, DataManager.cash]
