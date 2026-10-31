extends BaseInteractable
class_name DialogueInteractable

@export var npc_name: String
@export var dialogue: DialogueResource
@export var cue: String = "start"
@export var quest: Quest
@export var anim_player: AnimationPlayer
@export var anim_name: String

var cutscene_enabled: bool = false

func _ready() -> void:
	icon_display = get_icon_display()
	toggle_icon_visibility(false)
	
	if anim_player != null:
		cutscene_enabled = true
	
	var dialogue_state_context: DialogueStateContext = DialogueStateContext.new()
	dialogue_state_context.alias = npc_name
	dialogue_state_context.target = self
	add_child(dialogue_state_context)

func interact() -> void:
	if dialogue == null:
		printerr("Missing dialogue!")
	if cutscene_enabled == true:
		if anim_player == null:
			printerr("Missing animation player!")
		elif anim_name == null:
			printerr("Missing animation name!")
	
	DialogueManager.show_dialogue_balloon(dialogue, cue, cutscene_enabled)

func anim_play(s_mark: String = "", e_mark: String = "") -> void:
	anim_player.play_section_with_markers(anim_name, s_mark, e_mark)
