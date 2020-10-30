extends Area

# Can be selectet
# hardcoded: switches curso tor indoorCellCurser when indoorCells available
# TODO: Remove the hardcode here

class_name Selectable

var collision:CollisionShape
var shapeSize:Vector3

func get_class():
	return "Selectable"

func initialize(mesh):
	#shapeSize = _shapeSize
	var clickShape = mesh.create_convex_shape()
	var Collisionshape = CollisionShape.new()
	Collisionshape.shape = clickShape
	add_child(Collisionshape)
	collision = Collisionshape
	
	input_ray_pickable = true

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if(GameData.cameraAnchor.cursor_handler.Cursor != null):
		return
	if event.is_action_pressed("Mouse_Left_click"):
		GameData.cameraAnchor.SetActiveItem(get_parent())
		
		var cellSystem = get_parent().getFirstPartOrDefault("IndoorCellSystem")
		if cellSystem == null:
			return
			
		GameData.cameraAnchor.cursor_handler.set_cursor(
			IndoorCellSelectionCursor.new(
				cellSystem.size,
				cellSystem.cellSize,
				cellSystem.cells.keys(),
				get_parent()))
