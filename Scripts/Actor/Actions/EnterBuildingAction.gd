extends Action

class_name EnterBuildingAction

var path:Array
var exitPath:Array
var target
var speed:float
var astar:AStar
var nextPos:Vector3
var inBuilding:bool = false
var goExit:bool = false

func setActionParameter(actionName,actorSelf,params):
	ActionName = actionName
	for actor in actorSelf.GetVillage().ActorList:
		if actor.ActorID == params[0]:
			target = actor
			break
	if target == null:
		self.ActionFinished = true
	mySelf = actorSelf

func ProcessAction():
	if self.ActionFinished:
		return
	
	if !inBuilding:
		var move_vec = nextPos - mySelf.global_transform.origin
			
		if  move_vec.length() < 0.2:
			if path.size() > 0:
				nextPos = path[0]
				path.remove(0)
			else:
				self.inBuilding = true
				### #DEBUG DEBUG DEBUG
				## Exit building right after entering it
				OnCanceled()
		mySelf.global_transform.origin += move_vec.normalized() * speed
	elif !inBuilding && goExit:
		self.ActionFinished = true
	elif goExit:
		var move_vec = nextPos - mySelf.global_transform.origin
			
		if  move_vec.length() < 1:
			if path.size() > 0:
				nextPos =  exitPath[0]
				exitPath.remove(0)
			else:
				self.inBuilding = false
				self.ActionFinished = true
		mySelf.global_transform.origin += move_vec.normalized() * speed

func OnStart():
	var mobile = mySelf.getFirstPartOrDefault("Movable")
	if mobile == null:
		OnCanceled()
	else:
		speed = mobile.Move_Speed
		if target == null: 
			return
			
		var eingang = target.getFirstPartOrDefault("Eingang")
		if eingang == null: 
			return
		
		var eingangTarget = target.global_transform.origin + eingang.exitLocation
		var myPos = mySelf.global_transform.origin
		var dist = myPos - eingangTarget
		if dist.length() > 8:
			mySelf.QueueAction("FollowPathAction",[eingangTarget],true,false)
			return
			
		path.append(target.global_transform.origin + eingang.insideLocation)
		path.append(target.global_transform.origin + eingang.doorway)
		path.append(target.global_transform.origin + eingang.exitLocation)
		
		exitPath.append(target.global_transform.origin + eingang.exitLocation)
		exitPath.append(target.global_transform.origin + eingang.doorway)
		exitPath.append(target.global_transform.origin + eingang.insideLocation)
		
		if path.size() > 0:
			nextPos = path[0]
	
func OnCanceled():
	if inBuilding:
		goExit = true
		nextPos = exitPath[0]
		#mySelf.get_node("CollisionShape").disabled = true
	else:
		self.ActionFinished = true
		#mySelf.get_node("CollisionShape").disabled = false
	
func OnFinished():
	self.ActionFinished = true
	pass
