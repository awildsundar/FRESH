extends BaseInteractable
class_name SceneInteractable

@export_file(".tscn") var scene: String
@export var scene_type: TransitionManager.LOADING_SCREEN_TYPE = TransitionManager.LOADING_SCREEN_TYPE.DEFAULT
@export var animation_name: String = ""

func _ready() -> void:
	if minimap_icon != null:
		minimap_icon.icon.texture = minimap_icon.ICON_TEXTURES[minimap_icon.ICON_TYPE.SCENE]

func interact() -> void:
	if QuestManager.active_quest.quest_progression == 1:
		QuestManager.update_quest()
	
	if animation_name != "":
		var anim_player: AnimationPlayer = get_animation_player()
		if anim_player.has_animation(animation_name):
			anim_player.play(animation_name)
			await anim_player.animation_finished
		else:
			printerr("SceneInteractable: No animation found!")	

	TransitionManager.load_scene(scene, scene_type)
