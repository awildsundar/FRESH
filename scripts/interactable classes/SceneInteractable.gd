extends BaseInteractable
class_name SceneInteractable

@export_file(".tscn") var scene: String

func interact() -> void:
	get_tree().change_scene_to_file(scene)
