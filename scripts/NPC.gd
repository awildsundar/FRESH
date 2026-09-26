extends CharacterBody3D
class_name NPCComponent

var anim_player: AnimationPlayer

func _ready() -> void:
	for child in get_children():
		if child is AnimationPlayer:
			anim_player = child

func emote(emotion: String) -> void:
	anim_player.play(emotion)
