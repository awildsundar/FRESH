extends BaseInteractable
class_name DialogueInteractable

@export var npc_name: String
@export var dialogue: DialogueResource
@export var cue: String = "start"
@export var quest: Quest
@export var animation_name: String

@onready var anim_player: AnimationPlayer = self.get_animation_player()

var cutscene_enabled: bool = false

func _ready() -> void:
	if anim_player != null:
		cutscene_enabled = true
	
	if minimap_icon != null:
		minimap_icon.icon.texture = minimap_icon.ICON_TEXTURES[minimap_icon.ICON_TYPE.DIALOGUE]
	
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
		elif animation_name == null:
			printerr("Missing animation name!")
	
	DialogueManager.show_dialogue_balloon(dialogue, cue, cutscene_enabled)

func anim_play(s_mark: String = "", e_mark: String = "") -> void:
	anim_player.play_section_with_markers(animation_name, s_mark, e_mark)
