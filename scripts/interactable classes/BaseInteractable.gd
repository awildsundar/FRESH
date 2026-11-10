@abstract

extends CollisionObject3D
class_name BaseInteractable

var icon: Texture2D = preload("res://icon.svg")

func _ready() -> void:
	toggle_icon_visibility(false)

##Toggles the visibility of the icon
func toggle_icon_visibility(visibility: bool) -> void:
	var icon_display: Sprite3D = get_icon_display()
	if self.is_visible_in_tree():
		if visibility == true:
			icon_display.show()
		else:
			icon_display.hide()

##Returns the Sprite 3D icon of the interactable
func get_icon_display() -> Sprite3D:
	for child in get_children():
		if child is Sprite3D:
			child.texture = icon
			child.pixel_size = 0.005
			child.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			return child
	return null

##Returns the collision shape of the interactable
func get_collision_shape() -> CollisionShape3D:
	for child in get_children():
		if child is CollisionShape3D:
			return child
	return null

##Returns the meshes of the interactable
func get_mesh_instances() -> Array[MeshInstance3D]:
	var meshes: Array = []
	
	for child in get_children():
		if child is MeshInstance3D:
			meshes.append(child)
	
	return meshes

func get_player() -> OverworldCharacter:
	for child in get_tree().current_scene.get_children():
		if child is OverworldCharacter:
			return child
	return null

func get_animation_player() -> AnimationPlayer:
	for child in get_children():
		if child is AnimationPlayer:
			return child
	return null

func get_manager() -> OverWorldManager:
	if self.get_tree().current_scene is OverWorldManager:
		return self.get_tree().current_scene
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact() -> void:
	pass
