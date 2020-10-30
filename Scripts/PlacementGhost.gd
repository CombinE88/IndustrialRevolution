extends Spatial

class_name Placement_Ghost

func _init(parts:Array):
	for part in parts:
		add_child(part)

func getPartsOfType(type:String):
	var get_parts = []
	for part in get_children():
		if part.get_class() == type:
			get_parts.append(part)
	return get_parts
	
func getFirstPartOrDefault(type:String):
	for part in get_children():
		if part.get_class() ==  type:
			return part
	return null
