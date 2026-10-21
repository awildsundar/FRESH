extends Button
class_name ShopStockButton

var item: Item
var shop_manager: ShopManager

func _ready() -> void:
	text = "$" + str(item.price)
	icon = item.icon

func _on_mouse_entered() -> void:
	shop_manager.item_icon.texture = item.icon
	shop_manager.item_name.text = item.item_name
	shop_manager.item_description.text = item.description
	shop_manager.item_stats.text = "ATK: %d
	DEF: %d
	SPEED: %d
	OWNED: x%d" % [item.atk, item.def, item.speed, find_item_instances(item)]

func find_item_instances(searchable_item: Item) -> int:
	return DataManager.inventory.get(searchable_item, 0)

func _on_pressed() -> void:
	if DataManager.cash < item.price:
		return
	else:
		DataManager.cash -= item.price
	
	if DataManager.inventory.get(item) != null:
		DataManager.inventory[item] += 1
	else:
		DataManager.inventory.set(item, 1)
	
	if item.item_type != item.ITEM_TYPE.FOOD:
		disabled = true
	
	shop_manager.item_stats.text = "ATK: %d
	DEF: %d
	SPEED: %d
	OWNED: x%d" % [item.atk, item.def, item.speed, find_item_instances(item)]
	
	print(str(DataManager.cash))
	print(DataManager.inventory)
