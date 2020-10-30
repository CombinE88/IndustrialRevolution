extends CSGMesh

var path : = Array() setget set_path
var speed : = 10
var clampPos
var size:Vector2 = Vector2(0.5,0.5)

func _ready() -> void:
	set_process(false)

func _process(delta : float):
	var move_distance : float = speed * delta
	move_along_path(move_distance)
	pass

func _physics_process(delta):
	pass

func move_along_path(distance : float) -> void:
	var astar = get_parent().terrain.Astar_Navigation
	
	var prev_pos : = transform.origin
	for i in range(path.size()):
		var distance_to_next : = prev_pos.distance_to(clampPos)
		if distance <= distance_to_next && distance >= 0.0:
			transform.origin = prev_pos.linear_interpolate(clampPos, distance / distance_to_next)
			break
		elif distance < 0.0:
			transform.origin = clampPos
			set_process(false)
			break
		distance -= distance_to_next
		prev_pos = clampPos
		path.remove(0)
		if path.size() > 0:
			clampPos = clampNewPos(path[0])
	
func set_path(value : Array) -> void:
	path = value
	if value.size() == 0:
		return
		
	clampPos = clampNewPos(path[0])
	
	set_process(true)

func clampNewPos(currentPoint:int):
	var astar = get_parent().terrain.Astar_Navigation
	var currentCell = get_parent().terrain.findCellByCoordinates(astar.get_point_position(currentPoint))
	return Vector3(
		clamp(
			transform.origin.x,
			get_parent().terrain.get_centerOfCell(currentCell).x-2 + size.x,
			get_parent().terrain.get_centerOfCell(currentCell).x+2 - size.x),
		astar.get_point_position(currentPoint).y,
		clamp(
			transform.origin.z,
			get_parent().terrain.get_centerOfCell(currentCell).z-2 + size.y,
			get_parent().terrain.get_centerOfCell(currentCell).z+2 - size.y))
