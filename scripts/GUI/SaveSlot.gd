extends Panel
class_name SaveSlot

@export var slot_number: int = 1

@onready var slot_name: Label = $HBoxContainer/SlotName
@onready var save_button: Button = $HBoxContainer/SaveButton
@onready var load_button: Button = $HBoxContainer/LoadButton
@onready var delete_button: Button = $HBoxContainer/DeleteButton

func _ready() -> void:
	slot_name.text = "EMPTY SLOT" if SaveManager.get_save_info(slot_number) == {} else "%s - %s" % [SaveManager.get_save_info(slot_number)["story_act"], SaveManager.get_save_info(slot_number)["timestamp"]]


func _on_save_button_pressed() -> void:
	SaveManager.save_game(slot_number)
	slot_name.text = "%s - %s" % [SaveManager.get_save_info(slot_number)["story_act"], SaveManager.get_save_info(slot_number)["timestamp"]]


func _on_load_button_pressed() -> void:
	SaveManager.load_game(slot_number)


func _on_delete_button_pressed() -> void:
	SaveManager.delete_save(slot_number)
	slot_name.text = "EMPTY SLOT"
	
