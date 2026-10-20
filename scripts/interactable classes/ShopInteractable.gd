extends BaseInteractable
class_name ShopInteractable

enum SHOP_TYPE {
	BURGER,
	COFFEE,
	BAKERY
}

@export var shop_type: SHOP_TYPE

func interact() -> void:
	pass
