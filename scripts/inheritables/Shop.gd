extends Resource
class_name Shop

signal progressed

@export var shop_logo: Texture2D
@export var stock: Array[Item]
## Left value is the next level, right value is how much the player needs to buy
@export var level_requirements: Dictionary[int, int]
@export var level_locked_stock: Dictionary[int, Item]

@export var level: int = 1: 
	set(value):
		if value > level_locked_stock.size() + 1:
			value = level_locked_stock.size() + 1
		level = value
@export var level_progression: int = 0:
	set(value):
		level_progression = value
		progressed.emit(level_progression)
