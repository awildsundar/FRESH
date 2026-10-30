extends BaseInteractable
class_name SceneInteractable

@export_file(".tscn") var scene: String
@export var scene_type: TransitionManager.LOADING_SCREEN_TYPE = TransitionManager.LOADING_SCREEN_TYPE.DEFAULT

func interact() -> void:
	if DataManager.get_flag("arena_entered") == false:
		TransitionManager.load_scene(scene, scene_type)
		DataManager.set_flag("arena_entered", true)
