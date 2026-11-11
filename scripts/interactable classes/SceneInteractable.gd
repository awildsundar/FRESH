extends BaseInteractable
class_name SceneInteractable

@export_file(".tscn") var scene: String
@export var scene_type: TransitionManager.LOADING_SCREEN_TYPE = TransitionManager.LOADING_SCREEN_TYPE.DEFAULT
@export var animation_name: String = ""

func interact() -> void:
	if DataManager.get_flag("arena_entered") == false:
		if animation_name != "":
			var anim_player: AnimationPlayer = get_animation_player()
			if anim_player.has_animation(animation_name):
				anim_player.play(animation_name)
				await anim_player.animation_finished
			else:
				printerr("SceneInteractable: No animation found!")	

		TransitionManager.load_scene(scene, scene_type)
		DataManager.set_flag("arena_entered", true)
