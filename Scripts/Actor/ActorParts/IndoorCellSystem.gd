extends Part

class_name IndoorCellSystem

var cells:Dictionary = {}
var cellSize:Vector2
var size:Vector2

func get_class():
	return "IndoorCellSystem"

func initialize(_astarActorOrigin:Vector3,_size:Vector2,_cellSize:Vector2,_astar:AStar,_outsideConnections:Array):
	cellSize = _cellSize
	for x in _size.x:
		for y in _size.y:
			cells[Vector2(x,y)] = 0
	var astar = _astar
	var outsideConnections = _outsideConnections
	size = _size
	var astarActorOrigin = _astarActorOrigin
	
	for cell in cells.keys():
		
		var new_Id = astar.get_available_point_id()
		var newPos = astarActorOrigin + Vector3(
			-(size.x * cellSize.x / 2) + (cell.x * cellSize.x) + cellSize.x,
			0.1,
			-(size.y * cellSize.y / 2) + (cell.y * cellSize.y) + cellSize.y / 2)
		astar.add_point(new_Id, newPos)
		cells[cell] = new_Id
		
	for cell in cells.keys():
		if(cells.has(Vector2(cell.x-1,cell.y))):
			astar.connect_points(cells[cell], cells[Vector2(cell.x-1,cell.y)])
		if(cells.has(Vector2(cell.x-1,cell.y-1))):
			astar.connect_points(cells[cell], cells[Vector2(cell.x-1,cell.y-1)])
		if(cells.has(Vector2(cell.x,cell.y-1))):
			astar.connect_points(cells[cell], cells[Vector2(cell.x,cell.y-1)])
		if(cells.has(Vector2(cell.x+1,cell.y-1))):
			astar.connect_points(cells[cell], cells[Vector2(cell.x+1,cell.y-1)])
		#debug
		#var newcsg: = CSGMesh.new()
		#newcsg.mesh = SphereMesh.new()
		#newcsg.transform.origin = astar.get_point_position(cells[cell])
		#get_parent().get_parent().add_child(newcsg)
	
	for con in outsideConnections:
		astar.connect_points(findClosestId(cells.values(),con,astar),con)
		
			
func findClosestId(idArray:Array, id1:int, astar:AStar) -> int: 
	var id = idArray[0]
	for ident in idArray:
		var newDist = astar.get_point_position(ident).distance_to(astar.get_point_position(id))
		var oldDist = astar.get_point_position(id1).distance_to(astar.get_point_position(id))
		if newDist < oldDist:
			id = ident
	return id
