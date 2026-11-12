extends Menu
class_name UpgradeManager

@onready var shards_display: Label = $Control/HBoxContainer/Panel/MarginContainer/ShardsDisplay
@onready var upgrade_container: TabContainer = $Control/HBoxContainer/TabContainer

var player: OverworldCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	player.can_move = false
	player.overworld_manager.current_menu = self
	DataManager.shards_updated.connect(shards_changed)
	shards_changed(DataManager.shards)

func shards_changed(value: int) -> void:
	shards_display.text = "Shards: %d" % [value]

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.can_move = true
	player.overworld_manager.current_menu = null
	self.queue_free()
