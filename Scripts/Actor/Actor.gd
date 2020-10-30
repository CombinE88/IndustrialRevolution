extends KinematicBody

class_name Actor

var Owner:Player
var ActorID:int

var ActionQueue = []
var CurrentAction:Action
var Cell_Location:Vector2

func _ready():
	ActorID = GameData.GetNextFreeActorID()

func _initialize(player:Player):
	Owner = player

func GetVillage():
	return get_parent()

func _process(delta):
	if ActionQueue.size() <= 0:
		return
		
	for action in ActionQueue.duplicate():
		if action.ActionFinished:
			if action == CurrentAction:
				CurrentAction = null
			ActionQueue.erase(action)
			action.free()
		
	if ActionQueue.size() <= 0:
		return
		
	if CurrentAction == null || CurrentAction != ActionQueue[0]:
		
		CurrentAction = ActionQueue[0]
		CurrentAction.OnStart()
		return
		
	HandleAction(CurrentAction, delta)
	
func HandleAction(action:Action, delta):
	if action != null && action.ActionFinished:
		return
	action.ProcessAction(delta)
	
remote func CancleCurrentAction():
	
	if !GlobalFunctions.IsServer():
		rpc_id(1,"CancleCurrentAction")
		return
	else: 
		rpc("SyncCancleCurrentAction")
		SyncCancleCurrentAction()
	
remote func SyncCancleCurrentAction():
	if ActionQueue.size() > 0:
		ActionQueue[0].Cancle
	
remote func CancleActionQueue():
	if !GlobalFunctions.IsServer():
		rpc_id(1,"CancleActionQueue")
		return
	else:
		rpc("SyncCancleActionQueue")
		SyncCancleActionQueue()
	
remote func SyncCancleActionQueue():
	if ActionQueue.size() > 0:
		ActionQueue[0].Cancle
		ActionQueue.clear()
	
remote func QueueAction(_actionType:String,actionParams,first:bool = false,force:bool = false):
	if !GlobalFunctions.IsServer():
		rpc_id(1,"QueueAction",_actionType,actionParams,first,force)
		return
	else:
		rpc("SyncQueueAction",_actionType,actionParams,first,force)
		SyncQueueAction(_actionType,actionParams,first,force)
		
remote func SyncQueueAction(_actionType:String,actionParams,first:bool = false,force:bool = false):
	
	var actionType
	if _actionType == "FollowPathAction":
		actionType = load("res://Scripts/Actor/Actions/FollowPath.gd").new()
	elif _actionType == "EnterBuildingAction":
		actionType = load("res://Scripts/Actor/Actions/EnterBuildingAction.gd").new()
	else:
		return
		
	actionType.setActionParameter(_actionType,self,actionParams)
	if first:
		ActionQueue.push_front(actionType)
	elif force:
		for action in ActionQueue:
			action.OnCanceled()
		ActionQueue.append(actionType)
	else:
		ActionQueue.append(actionType)
		
func GetActionName():
	if CurrentAction != null:
		return CurrentAction.ActionName
	else:
		return "idle"
		
func IsActorIdle() -> bool:
	return CurrentAction == null
		
func getPartsOfType(type:String):
	var get_parts = []
	for part in get_children():
		if part.get_class() == type:
			get_parts.append(part)
	return get_parts
	
func getFirstPartOrDefault(type:String):
	for part in get_children():
		if part.get_class() == type:
			return part
	return null
	
func UpdateParts():
	for part in get_children():
		if part.has_method("Update"):
			part.Update()
