extends CSGCombiner

class_name MeshManagerOuter

func get_class():
	return "MeshManagerOuter"
		
func _process(delta):
	visible = GameData.game_world.selectedItem != get_parent()
