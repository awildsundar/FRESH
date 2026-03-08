extends BaseInteractable
class_name DialogueInteractable

@export_file("*.json") var timeline: String = "res://dialogues/tests/test1.json"
# TODO: replace Node3D with custom class
@export var ch_list: Dictionary[String, Color]
@export var main_ch: String = "Archita"
@export var important_timeline: bool = false
@export var oneshot: bool = false
@export var cutscene_name: String
@export var cutscene_player: AnimationPlayer

var dialogue_ui: Resource = preload("res://scenes/dialogue ui/BasicDialogue.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact() -> void:
	var dialogue_display: BasicDialogue = dialogue_ui.instantiate()
	add_child(dialogue_display)
	dialogue_display.ch_list = ch_list
	dialogue_display.main_ch = main_ch
	dialogue_display.important_timeline = important_timeline
	dialogue_display.timeline = timeline
	if cutscene_player != null:
		dialogue_display.cutscene_name = cutscene_name
		dialogue_display.cutscene_player = cutscene_player
		cutscene_player.seek(0, true)
	
	dialogue_display.play()
	
	await SignalBus.timeline_ended
	cutscene_player.seek(cutscene_player.current_animation_length)
	
	if oneshot:
		self.set_script(null)
