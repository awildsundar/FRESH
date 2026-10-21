extends Resource
class_name Item

enum ITEM_TYPE {
	STORY,
	FOOD,
	CLOTHING
}

@export_category("Basics")
@export var item_type: ITEM_TYPE
@export var item_name: String
@export var icon: Texture2D
@export_multiline var description: String

@export_category("Purchasables")
@export var price: int
@export var atk: int
@export var def: int
@export var speed: int
