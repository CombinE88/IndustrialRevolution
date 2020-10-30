extends KinematicBody

var path : = Array() setget set_path
var speed : = 10
var size:Vector2 = Vector2(0.5,0.5)

func _physics_process(delta):
	if path.size() > 0:
		var move_vec = clampNewPos(path[0]) - global_transform.origin
		if(move_vec.length() < 0.1):
			path.remove(0)
		else:
			move_and_slide(move_vec.normalized() * speed, Vector3(0,1,0))

func set_path(value : Array) -> void:
	path = value
	if value.size() == 0:
		return
		
func findPath(astar:AStar,clickPoint:Vector3):
	var new_path = astar.get_id_path(
				astar.get_closest_point(transform.origin),
				astar.get_closest_point(clickPoint))
	set_path(new_path) 

func clampNewPos(currentPoint:int):
	var astar = get_parent().terrain.Astar_Navigation
	var currentCell = get_parent().terrain.findCellByCoordinates(astar.get_point_position(currentPoint))
	return Vector3(
		clamp(
			transform.origin.x,
			get_parent().terrain.get_centerOfCell(currentCell).x-2 + size.x,
			get_parent().terrain.get_centerOfCell(currentCell).x+2 - size.x),
		astar.get_point_position(currentPoint).y + 1,
		clamp(
			transform.origin.z,
			get_parent().terrain.get_centerOfCell(currentCell).z-2 + size.y,
			get_parent().terrain.get_centerOfCell(currentCell).z+2 - size.y))
