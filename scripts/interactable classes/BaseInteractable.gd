@abstract

extends CollisionObject3D
class_name BaseInteractable

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact() -> void:
	pass
