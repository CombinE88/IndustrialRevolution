extends CSGCombiner

class_name MeshManagerInner

func get_class():
	return "MeshManagerInner"

func _process(delta):
	visible = GameData.game_world.selectedItem == get_parent()
