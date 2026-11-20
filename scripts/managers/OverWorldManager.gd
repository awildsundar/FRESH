extends Node3D
class_name OverWorldManager

@export var location: DataManager.LOCATION
@export var quest: Quest

@onready var enemy_chain_timer: Timer = Timer.new()

var current_menu: Menu = null:
	set(value):
		if value != null:
			player.base_gui.hide()
			show_enemy_locations(true, false)
		else:
			player.base_gui.show()
		current_menu = value
		

var player: OverworldCharacter
var scan_material: ShaderMaterial

var enemy_locations: Array[Arena]
var enemies_visible: bool = false

var arena_scene: PackedScene = preload("uid://b7q4webcoivt4")

func _ready() -> void:
	DataManager.last_location = location
	
	for child in self.get_children():
		if child is OverworldCharacter:
			player = child
	
	scan_material = player.scan_shader.mesh.surface_get_material(0)
	scan_material.set_shader_parameter("shader_parameter/visibility", 0.0)
	
	if QuestManager.active_quest == null:
		if quest.quest_progression == 0:
			QuestManager.start_quest(quest)
	
	self.add_child(enemy_chain_timer)
	enemy_chain_timer.one_shot = true

func show_enemy_locations(custom_value: bool = false, value: bool = false) -> void:
	if custom_value == false:
		enemies_visible = !enemies_visible
	else:
		enemies_visible = value
	
	for enemy_location: Arena in enemy_locations:
		if enemies_visible == true:
			enemy_location.enable_interaction(true)
		else:
			enemy_location.enable_interaction(false)
	
	if enemies_visible == true && current_menu == null:
		player.scan_shader.show()
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(scan_material, "shader_parameter/visibility", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	else:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(scan_material, "shader_parameter/visibility", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tween.finished
		player.scan_shader.hide()
