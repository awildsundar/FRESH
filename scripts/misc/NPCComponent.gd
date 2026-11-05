extends CharacterBody3D
class_name NPCComponent

@export var npc_name: String

var anim_player: AnimationPlayer

func _ready() -> void:
	if npc_name == "":
		npc_name = self.name
	
	for child in get_children():
		if child is AnimationPlayer:
			anim_player = child
	
	var dialogue_state_context: DialogueStateContext = DialogueStateContext.new()
	dialogue_state_context.alias = npc_name
	dialogue_state_context.target = self
	add_child(dialogue_state_context)

func emote(emotion: String) -> void:
	anim_player.play(emotion)
