extends BaseInteractable
class_name SceneInteractable

@export_file(".tscn") var scene: String
# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact() -> void:
	get_tree().change_scene_to_file(scene)
