extends Action

class_name FollowPathAction

var path:Array
var target:Vector3
var speed:int
var astar:AStar
var nextPos:Vector3

func setActionParameter(actionName,actorSelf,params):
	ActionName = actionName
	target = params[0]
	mySelf = actorSelf

func ProcessAction(delta):
	if self.ActionFinished:
		return
		
	var move_vec = nextPos - mySelf.global_transform.origin
	var direction = (nextPos - mySelf.global_transform.origin).normalized()
	if move_vec.length() < 1:
		if path.size() > 0:
			nextPos = CalculateNextPosition()
			path.remove(0)
		else:
			self.ActionFinished = true
	#mySelf.rotation.y = direction.y
	mySelf.move_and_slide(direction * speed, Vector3(0,1,0))

func OnStart():
	var mobile = mySelf.getFirstPartOrDefault("Movable")
	if mobile == null:
		OnCanceled()
	else:
		speed = mobile.Move_Speed
		astar = mySelf.GetVillage().Astar_Navigation
		var targetpoint = astar.get_closest_point(target)
		var selfpoint = astar.get_closest_point(mySelf.global_transform.origin)
		path = astar.get_id_path(
			selfpoint,
			targetpoint)
		
		if path.size() > 0:
			nextPos = CalculateNextPosition()
			
func CalculateNextPosition() -> Vector3:
	var myVillageTerrain = mySelf.GetVillage().Village_Terrain
		
	var targetCell = myVillageTerrain.findCellByCoordinates(
		astar.get_point_position(path[0]))
			
	var myCell = myVillageTerrain.findCellByCoordinates(mySelf.transform.origin)
	var targetPos = astar.get_point_position(path[0])
	
	if mySelf.GetVillage().get_node("RoadNetwork").roadCells.has(targetCell):
		var forward = (astar.get_point_position(path[0]) - mySelf.global_transform.origin).normalized()
		forward = forward.rotated(Vector3(0,1,0),deg2rad(-90))
		forward.y = 0
		targetPos += forward*1.2
	return targetPos

func OnCanceled():
	ActionFinished = true
	pass
	
func OnFinished():
	ActionFinished = true
	pass
